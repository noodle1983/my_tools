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
	print( "用法:" )
	print( "创建excel表: lua XlsParser.lua -c xxx.lua" )
	print( "导出excel表: lua XlsParser.lua -d xxx.xls" )
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
	elseif cfg.enable_sheet then
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
                end
                sheet_index = sheet_index + 1
            end
		end

        book:SaveAs( lfs.currentdir() .. "./" .. table_name .. ".xlsx" )
		excel:Quit()
	else
		local excel = luacom.CreateObject("Excel.Application")
		excel.Application.DisplayAlerts = 0
		local book  = excel.Workbooks:Add()
		local sheet = book.Worksheets(1)
		excel.Visible = false
		for i = 1, #cfg, 1 do
			create_xls_title( excel, sheet, i, cfg[i] )
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
	cell.Value2 = info.Name
	local color = get_cell_color( info )
	cell:Select()
	excel.Selection.Interior.Color = color
	excel.Selection.Validation:Add(3, nil, nil, "a, b, c", nil)
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
		local cell = sheet.Cells(1, column)
		local name = cell.Value2
		if name then
			cell:Select()
			local color = excel.Selection.Interior.Color
			if color == COLOR_RED then
				table.insert( name_list, { Name = name, Server = true, Client = false } )
			elseif color == COLOR_GREEN then
				tinsert( name_list, { Name = name, Server = true, Client = true } )
			elseif color == COLOR_YELLOW then
				table.insert( name_list, { Name = name, Server = false, Client = true } )
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
	for row = 2, ROW_MAX, 1 do
		local index = sheet.Cells(row, 1).Value2
		if index then
			local row_str = sformat( "\t[%d] = { ",  sheet.Cells(row, 1).Value2 )
			for column = 2, #name_list, 1 do
				if name_list[column].Server then
					row_str = row_str .. name_list[column].Name .. " = " .. (sheet.Cells(row, column).Value2 or "nil") .. ", "
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


