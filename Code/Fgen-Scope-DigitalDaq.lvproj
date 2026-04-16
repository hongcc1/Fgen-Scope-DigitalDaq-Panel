<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="25008000">
	<Property Name="CCSymbols" Type="Str">DO_ONBOARD_CLK,TRUE;MARKER0_EXPORT_PFI,TRUE;</Property>
	<Property Name="NI.LV.All.SaveVersion" Type="Str">25.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="SubVI" Type="Folder" URL="../SubVI">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="Typedef" Type="Folder" URL="../Typedef">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="Sinc generator to TDMS.vi" Type="VI" URL="../Sinc generator to TDMS.vi"/>
		<Item Name="Test Automatation Example1.vi" Type="VI" URL="../Test Automatation Example1.vi"/>
		<Item Name="Test Panel 2.vi" Type="VI" URL="../Test Panel 2.vi"/>
		<Item Name="Test Panel.vi" Type="VI" URL="../Test Panel.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
