assert( require "luacom" )
assert( require "lfs" )

local sformat, tinsert = string.format, table.insert

COLOR_RED = 255
COLOR_GREEN = 65280
COLOR_YELLOW = 65535

COLUMN_MAX = 512
ROW_MAX = 65536

function check_args()
	if #arg ~= 2 then
		return false
	end
	if (not string.match( arg[2], ".xls" )) and (not string.match( arg[2], ".lua" )) then
		return false
	end
	return true
end

function show_help()
	print( "�÷�:" )
	print( "����excel��: lua XlsParser.lua -c xxx.lua" )
	print( "����excel��: lua XlsParser.lua -d xxx.xls" )
end

function parse_args()
	if arg[1] == "-c" then
		create_xls( arg[2] )
	elseif arg[1] == "-d" then
		dump_xls( arg[2] )
	end
end

function create_xls( filename )
	dofile( filename )
	local table_name = string.sub( filename, 1, #filename-4 )
	local cfg = _G[table_name]
	if not cfg then
		error( sformat( "Table Name must be %s", table_name ) )
	else
        local excel = luacom.CreateObject("Excel.Application")
        excel.Application.DisplayAlerts = 0
        excel.Visible = false
        local book  = excel.Workbooks:Add()

        local sheet_index = 1
		for tbl_name, tbl_value in pairs(cfg) do
            if type(tbl_value) == "table" then
                local sheet = nil
                if ( sheet_index > book.Worksheets.Count ) then
                    sheet = book.Worksheets:Add()
                else
                    sheet = book.Worksheets(sheet_index)
                end
                sheet:Select()
                sheet.Name = tbl_name
                for attr_index = 1, #tbl_value, 1 do
                    create_xls_title( excel, sheet, attr_index, tbl_value[attr_index] )
                    create_validation( excel, sheet, attr_index, tbl_value[attr_index] )
                end
                sheet_index = sheet_index + 1
            end
		end

        book:SaveAs( lfs.currentdir() .. "./" .. table_name .. ".xlsx" )
		excel:Quit()
	end
end

function get_cell_color( info )
	if info.Server == true and info.Client == true then
		return COLOR_GREEN
	elseif info.Server == true then
		return COLOR_RED
	else
		return COLOR_YELLOW
	end
end

function create_xls_title( excel, sheet, column, info )
	local cell = sheet.Cells(1, column)
	local color = get_cell_color( info )
	cell.Value2 = info.Type or "any"
	cell.Value2 = (string.sub(cell.Value2, 1, 5) == "enum:" and "enum") or  cell.Value2
	cell:Select()
	excel.Selection.Interior.Color = color

	cell = sheet.Cells(2, column)
	cell.Value2 = info.Name
end

function create_validation( excel, sheet, column, info )
    if not info.Type then
        return
    elseif info.Type == "int" then
        local value_cell = sheet.Columns(column)
        value_cell:Select()
        excel.Selection.Validation:Add(1, nil, nil, -9223372036854775807, 9223372036854775807)
    elseif info.Type == "float" then
        local value_cell = sheet.Columns(column)
        value_cell:Select()
        excel.Selection.Validation:Add(2, nil, nil, -9223372036854775807, 9223372036854775807)
    elseif string.sub(info.Type, 1, 5) == "enum:" then
        local value_cell = sheet.Columns(column)
        value_cell:Select()
        excel.Selection.Validation:Add(3, nil, nil, string.sub(info.Type, 6), nil)
    end
end

function dump_xls( filename )

	local excel = luacom.CreateObject("Excel.Application")
	excel.Application.DisplayAlerts = 0
	local book = excel.Workbooks:Open( lfs.currentdir() .. "./" .. filename )
    local sheet_num = book.Worksheets.Count
    for sheet_index = 1, sheet_num, 1 do
        local sheet = book.Worksheets(sheet_index)
        sheet:Select()
		local table_name = sheet.Name
		if  string.sub(table_name, 1, 5) == "Sheet" then
			table_name = string.sub( filename, 1, #filename-4 )
		end

        if sheet.Cells(1, 1).Value2 then
            dump_to_lua( table_name, sheet, excel )
            dump_to_csharp( table_name, sheet, excel )
        end
    end
	excel:Quit()
end

function get_name_list( sheet, excel )
	local name_list = {}
	for column = 1, COLUMN_MAX, 1 do
		local name_cell = sheet.Cells(2, column)
		local name = name_cell.Value2
		local cell = sheet.Cells(1, column)
		local value_type = cell.Value2
		if name and value_type then
			cell:Select()
			local color = excel.Selection.Interior.Color
			if color == COLOR_RED then
				table.insert( name_list, { Name = name, Server = true, Client = false, Type = value_type } )
			elseif color == COLOR_GREEN then
				tinsert( name_list, { Name = name, Server = true, Client = true, Type = value_type } )
			elseif color == COLOR_YELLOW then
				table.insert( name_list, { Name = name, Server = false, Client = true, Type = value_type } )
			end
		else
			break
		end
	end
	return name_list
end

function dump_to_lua( table_name, sheet, excel )
	local name_list = get_name_list( sheet, excel )
	local new_name = "prop" .. table_name
	local f = io.open( lfs.currentdir() .. "./" .. new_name .. ".lua", "w" )
	f:write( sformat( "%s = \n", new_name ) )
	f:write( "{\n" )
	for row = 3, ROW_MAX, 1 do
       
		local index = sheet.Cells(row, 1).Value2
		if index then
			local row_str = sformat( "\t[%d] = { Id = %d, ",  
                sheet.Cells(row, 1).Value2,
                sheet.Cells(row, 1).Value2 )
			for column = 2, #name_list, 1 do
				if name_list[column].Server then
                    local value =  (sheet.Cells(row, column).Value2 or "nil")
                    if name_list[column].Type == "enum" then
                        local test_enum_value = string.gmatch(value, "([-%d]+):")() 
                        if test_enum_value then
                            value = test_enum_value
                        end
                    elseif name_list[column].Type == "string" then
                        value = "\"" .. value .. "\""
                    end
					row_str = row_str .. name_list[column].Name .. " = " .. value .. ", "
				end
			end
			row_str = row_str .. "},\n"
			f:write( row_str )
		else
			break
		end
	end
	f:write( "}\n" )
	f:close()
end

function dump_to_csharp( table_name, sheet, excel )
end

function main()
	if not check_args() then
		show_help()
	else
		parse_args()
	end
end

main()


