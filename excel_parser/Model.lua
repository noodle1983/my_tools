Model =
{
    Model1 = {
        { Name = "ID", 			Alias = "ID",        Server = true, 		Client = true , Type = "int"},	--��һ��
        { Name = "speed", 		Alias = "�ٶ�",      Server = true, 		Client = true , Type = "float"},	--�ڶ���
        { Name = "Name", 		Alias = "����",      Server = true, 		Client = true , Type = "string"},	--�ڶ���
        { Name = "Path", 		Alias = "·��",      Server = false, 	    Client = true },	--������
        { Name = "Type", 		Alias = "����",      Server = true, 		Client = false, Type = "enum:0:a, 1:b, 2:c" },	--������
    },
}

