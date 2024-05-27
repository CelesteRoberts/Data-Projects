-- SKILLS USED: create table, define data types, establish key contraints

create schema if not exists bikeshop;

use bikeshop;

create table letterstyle
(
letterstyleid					varchar(20) not null,
letterstyledescription			varchar(100),

primary key (Letterstyleid)

);

create table manufacturer
(
manufacturerid		int not null,
manufacturername	varchar(30),
contactname			varchar(50),
phone				varchar(20),
address				varchar(50),
zipcode				varchar(10),
cityid				int,
balancedue 			decimal(8,2),

primary key (manufacturerid)

);

create table bikecomponent
(
componentid			int not null,
manufacturerid		int not null,
productnumber		varchar(30),
road				varchar(30),
category			varchar(30),
length				int,
height				decimal(8,2),
width				decimal(8,3),
weight				int,
year_made			year,
endyear				year,
componentdescription	varchar(100),
listprice			int,
estimatedcost		decimal(8,2),
quantityonhand		int,

primary key (componentid),
foreign key (manufacturerid) references manufacturer (manufacturerid)
);

create table modeltype
(
modeltype 		varchar(20) not null,
componentid		int not null, 
modeltypedescription	varchar(50),

primary key (modeltype),
foreign key (componentid) references bikecomponent (componentid)
);

create table paint
(
paintid		int not null,
colorname	varchar(50),
colorstyle  varchar(50),
colorlist	varchar(50),
dateintroduced	date,
datediscontinued	date null,

primary key (paintid)
);

create table bicycle 
(
serialnumber		int not null,
customerid			int,
modeltype			varchar(20) not null,
paintid				int not null,
framesize			int,
orderdate			date,
startdate			date,
shipdate			date,
shipemployee		int,
frameassembler		int,
painter				int,
construction		varchar(50),
waterbottlebrazeons		int,
customname			varchar(50),
letterstyleid			varchar(30),
StoreID				int,
Employeeid			int,
toptube				decimal(8,2),
chainstay			decimal(8,2),
headtubeangle		decimal (6,2),
seattubeangle		decimal(6,2),
listprice			decimal(8,2),
saleprice			decimal(8,2),
salestax			decimal(8,2),
salesstate			varchar(20),
shipprice			int,
frameprice			decimal(8,3),
componentlist		int,

primary key (serialnumber),
foreign key (modeltype) references modeltype (modeltype),
foreign key (paintid) references paint (paintid),
foreign key (letterstyleid) references letterstyle (letterstyleid)

);

create table bikeparts
(
serialnumber 	int not null,
componentid		int not null,
substituteid	int,
location		varchar(30),
quantity		int,
dateinstalled	date null,
employeeid		int,

primary key (serialnumber, componentid),
foreign key (serialnumber) references bicycle (serialnumber), 
foreign key (componentid) references bikecomponent (componentid)
);

create table tubematerial
(
tubeid		int not null,
material		varchar(20),
tubedescription	varchar(50),
diameter		decimal(8,2),
thickness		int,
roundness		varchar(20),
weight		decimal(8,2),
stiffness	int,
listprice	decimal(8,2),
construction	varchar(50),

primary key (tubeid)
);

create table biketubes
(
serialnumber		int not null,
tubeid				int not null,
tubename			varchar(20) not null,
length				int,

primary key (serialnumber, tubeid, tubename),
foreign key (serialnumber) references bicycle (serialnumber),
foreign key (tubeid) references tubematerial (tubeid)
);

