Model =
{
    Model1 = {
        { Name = "ID", 			Server = true, 		Client = true , Type = "int"},	--第一列
        { Name = "speed", 		Server = true, 		Client = true , Type = "float"},	--第二列
        { Name = "Name", 		Server = true, 		Client = true , Type = "string"},	--第二列
        { Name = "Path", 		Server = false, 	Client = true },	--第三列
        { Name = "Type", 		Server = true, 		Client = false, Type = "enum:0:a, 1:b, 2:c" },	--第四列
    },
}

