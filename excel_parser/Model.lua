Model =
{
    Model1 = {
        { Name = "ID", 			Server = true, 		Client = true , Type = "int"},	--��һ��
        { Name = "speed", 		Server = true, 		Client = true , Type = "float"},	--�ڶ���
        { Name = "Name", 		Server = true, 		Client = true , Type = "string"},	--�ڶ���
        { Name = "Path", 		Server = false, 	Client = true },	--������
        { Name = "Type", 		Server = true, 		Client = false, Type = "enum:0:a, 1:b, 2:c" },	--������
    },
}

