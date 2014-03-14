Model =
{
    Model1 = {
        { Name = "ID", 			Alias = "ID",        Server = true, 		Client = true , Type = "int"},	--第一列
        { Name = "speed", 		Alias = "速度",      Server = true, 		Client = true , Type = "float"},	--第二列
        { Name = "Name", 		Alias = "名字",      Server = true, 		Client = true , Type = "string"},	--第二列
        { Name = "Path", 		Alias = "路径",      Server = false, 	    Client = true },	--第三列
        { Name = "Type", 		Alias = "类型",      Server = true, 		Client = false, Type = "enum:0:a, 1:b, 2:c" },	--第四列
    },
}

