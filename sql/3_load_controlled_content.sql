--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.24
-- Dumped by pg_dump version 10.4

-- Started on 2018-11-10 10:25:18 PST


--
-- TOC entry 3174 (class 0 OID 130221)
-- Dependencies: 178
-- Data for Name: DataSet; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3175 (class 0 OID 130230)
-- Dependencies: 179
-- Data for Name: DataSetAttributes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--



--
-- TOC entry 3176 (class 0 OID 130243)
-- Dependencies: 180
-- Data for Name: DataSetEntities; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3177 (class 0 OID 130249)
-- Dependencies: 181
-- Data for Name: DataSetKeywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3178 (class 0 OID 130256)
-- Dependencies: 182
-- Data for Name: DataSetMethods; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3179 (class 0 OID 130262)
-- Dependencies: 183
-- Data for Name: DataSetPersonnel; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3180 (class 0 OID 130265)
-- Dependencies: 184
-- Data for Name: DataSetSites; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--



--
-- TOC entry 3181 (class 0 OID 130269)
-- Dependencies: 185
-- Data for Name: DataSetTemporal; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3182 (class 0 OID 130272)
-- Dependencies: 186
-- Data for Name: EMLAttributeCodeDefinition; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3183 (class 0 OID 130278)
-- Dependencies: 187
-- Data for Name: EMLKeywordTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLKeywordTypeList" ("KeywordType", "TypeDefinition") FROM stdin;
place	\N
theme	\N
taxonomic	\N
stratum	\N
temporal	\N
\.


--
-- TOC entry 3184 (class 0 OID 130284)
-- Dependencies: 188
-- Data for Name: EMLMeasurementScaleList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLMeasurementScaleList" ("measurementScale") FROM stdin;
dateTime
interval
nominal
ordinal
ratio
\.


--
-- TOC entry 3185 (class 0 OID 130287)
-- Dependencies: 189
-- Data for Name: EMLNumberTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLNumberTypeList" ("NumberType") FROM stdin;
integer
natural
real
whole
\.


--
-- TOC entry 3186 (class 0 OID 130290)
-- Dependencies: 190
-- Data for Name: EMLStorageTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLStorageTypeList" ("StorageType", "typeSystem") FROM stdin;
anyURI	http://www.w3.org/2001/XMLSchema-datatypes
boolean	http://www.w3.org/2001/XMLSchema-datatypes
byte	http://www.w3.org/2001/XMLSchema-datatypes
date	http://www.w3.org/2001/XMLSchema-datatypes
dateTime	http://www.w3.org/2001/XMLSchema-datatypes
decimal	http://www.w3.org/2001/XMLSchema-datatypes
double	http://www.w3.org/2001/XMLSchema-datatypes
duration	http://www.w3.org/2001/XMLSchema-datatypes
float	http://www.w3.org/2001/XMLSchema-datatypes
gDay	http://www.w3.org/2001/XMLSchema-datatypes
gMonth	http://www.w3.org/2001/XMLSchema-datatypes
gMonthDay	http://www.w3.org/2001/XMLSchema-datatypes
gYear	http://www.w3.org/2001/XMLSchema-datatypes
gYearMonth	http://www.w3.org/2001/XMLSchema-datatypes
int	http://www.w3.org/2001/XMLSchema-datatypes
integer	http://www.w3.org/2001/XMLSchema-datatypes
long	http://www.w3.org/2001/XMLSchema-datatypes
short	http://www.w3.org/2001/XMLSchema-datatypes
string	http://www.w3.org/2001/XMLSchema-datatypes
time	http://www.w3.org/2001/XMLSchema-datatypes
\.




--
-- TOC entry 3188 (class 0 OID 130300)
-- Dependencies: 192
-- Data for Name: EMLUnitTypes; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLUnitTypes" (id, name, dimension_name, dimension_power) FROM stdin;
acceleration	acceleration	length	-2
amount	amount	amount	\N
amountOfSubstanceConcentration	amountOfSubstanceConcentration	amount	-3
amountOfSubstanceWeight	amountOfSubstanceWeight	amount	-1
amountOfSubstanceWeightFlux	amountOfSubstanceWeightFlux	amount	-1
angle	angle	angle	\N
area	area	length	2
arealDensity	arealDensity	dimensionless	-2
arealMassDensity	arealMassDensity	mass	-2
arealMassDensityRate	arealMassDensityRate	mass	-2
capacitance	capacitance	mass	-1
catalyticActivity	catalyticActivity	time	-1
charge	charge	charge	\N
conductance	conductance	mass	-1
current	current	charge	-1
currentDensity	currentDensity	charge	-1
dimensionless	dimensionless	dimensionless	\N
doseEquivalent	doseEquivalent	time	-2
energy	energy	mass	2
force	force	mass	-2
frequency	frequency	time	-1
illuminance	illuminance	luminosity	-2
inductance	inductance	mass	2
length	length	length	\N
lengthReciprocal	lengthReciprocal	length	-1
luminance	luminance	luminosity	-2
luminosity	luminosity	luminosity	\N
magneticFieldStrength	magneticFieldStrength	charge	-1
magneticFlux	magneticFlux	mass	2
magneticFluxDensity	magneticFluxDensity	mass	-1
mass	mass	mass	\N
massDensity	massDensity	mass	-3
massFlux	massFlux	mass	-1
massPerMass	massPerMass	mass	-1
massSpecificCount	massSpecificCount	dimensionless	-1
massSpecificLength	massSpecificLength	length	-1
potentialDifference	potentialDifference	mass	2
power	power	mass	2
pressure	pressure	mass	-2
radionucleotideActivity	radionucleotideActivity	time	-1
resistance	resistance	mass	2
resistivity	resistivity	mass	3
specificArea	specificArea	mass	-1
specificEnergy	specificEnergy	time	-2
specificVolume	specificVolume	mass	-1
speed	speed	length	-1
temperature	temperature	temperature	\N
time	time	time	\N
transmissivity	transmissivity	length	2
volume	volume	length	3
volumePerVolume	volumePerVolume	length	3
volumetricArea	volumetricArea	length	3
volumetricDensity	volumetricDensity	dimensionless	-3
volumetricMassDensityRate	volumetricMassDensityRate	mass	-3
volumetricRate	volumetricRate	length	3
NULL	Null unit type	Null	0
timeReciprocal	timeReciprocal	time	-1
numberPerNumber	numberPerNumber	count	1
volumetricMassDensity	volumetricMassDensity	mass	\N
areaMassDensityRate	areaMassDensityRate	mass	\N
arealDensityRate	arealDensityRate	area	\N
massPerMassRate	massPerMassRate	mass	-1
massRate	massRate	mass	-1
massDensityRate	massDensityRate	mass	-1
amountOfSubstanceFlux	amountOfSubstanceFlux	amount	-1
radioactivity	radioactivity	time	-1
molePerMeterSquaredPerSecond	molePerMeterSquaredPerSecond	amount	\N
\.




--
-- TOC entry 3187 (class 0 OID 130293)
-- Dependencies: 191
-- Data for Name: EMLUnitDictionary; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."EMLUnitDictionary" (id, name, custom, "unitType", abbreviation, "multiplierToSI", "parentSI", "constantToSI", description) FROM stdin;
ampere	ampere	f	current	A	1	\N	\N	SI unit of electrical current
amperePerMeter	amperePerMeter	f	magneticFieldStrength	A/m	1	\N	\N	ampere per meter
amperePerSquareMeter	amperePerSquareMeter	f	currentDensity	A/m²	1	\N	\N	ampere per meter squared
are	are	f	area	a	100	squareMeter	\N	100 square meters
atmosphere	atmosphere	f	pressure	atm	101325	pascal	\N	1 atmosphere = 101325 pascals
bar	bar	f	pressure	bar	100000	pascal	\N	1 bar = 100000 pascals
becquerel	becquerel	f	radionucleotideActivity	Bq	1	\N	\N	becquerel
britishThermalUnit	britishThermalUnit	f	energy	btu	1055.0559	joule	\N	1 btu = 1055.0559 J
bushel	bushel	f	volume	b	0.035239	liter	\N	1 bushel = 35.23907 liters
bushelsPerAcre	bushelsPerAcre	f	volumetricArea	\N	0.00870	litersPerSquareMeter	\N	bushels per acre -- 1 bushel = 35.23907 liters/1 acre = 4046.8564 squareMeters
calorie	calorie	f	energy	cal	4.1868	joule	\N	1 cal = 4.1868 J
candela	candela	f	luminosity	cd	1	\N	\N	SI unit of luminosity
candelaPerSquareMeter	candelaPerSquareMeter	f	luminance	cd/m²	1	\N	\N	candela Per Square Meter
centigram	centigram	f	mass	cg	0.00001	kilogram	\N	0.00001 kg
centimeter	centimeter	f	\N	cm	0.01	meter	\N	.01 meters
centimeterPerYear	centimeterPerYear	f	speed	cm/year	0.000000000317098	metersPerSecond	\N	centimeter Per Year
centisecond	centisecond	f	\N	csec	0.01	second	\N	1/100 of a second
coulomb	coulomb	f	charge	C	1	\N	\N	SI unit of charge
cubicCentimetersPerCubicCentimeters	cubicCentimetersPerCubicCentimeters	f	volumePerVolume	\N	1	\N	\N	cubic centimeters per cubic centimeter
cubicFeetPerSecond	cubicFeetPerSecond	f	volumetricRate	ft³/sec	28.316874	litersPerSecond	\N	cubic feet per second
cubicInch	cubicInch	f	volume	in³	0.000016387064	liter	\N	cubic inch
cubicMeter	cubicMeter	f	volume	m³	1	\N	\N	cubic meter
cubicMeterPerKilogram	cubicMeterPerKilogram	f	specificVolume	m³/kg	1	\N	\N	cubic meters per kilogram
cubicMetersPerSecond	cubicMetersPerSecond	f	volumetricRate	m³/s	1	litersPerSecond	\N	cubic meters per second
cubicMicrometersPerGram	cubicMicrometersPerGram	f	specificVolume	µm³/kg	1	\N	\N	cubic micrometers per gram
day	day	t	time	day	86400	second	\N	day (86400 seconds)
decibar	decibar	t	pressure	dbar	10000	pascal	\N	decibar = 0.1 bar
decigram	decigram	f	mass	dg	0.0001	kilogram	\N	0.0001 kg
decimeter	decimeter	f	\N	dm	0.1	meter	\N	.1 meters
decisecond	decisecond	f	\N	dsec	0.1	second	\N	1/10 of a second
dekagram	dekagram	f	mass	dag	0.01	kilogram	\N	.01 kg
dekameter	dekameter	f	\N	dam	10	meter	\N	10 meters
dekasecond	dekasecond	f	\N	dasec	10	second	\N	10 seconds
disintegrationsPerMinute	disintegrationsPerMinute	t	radionucleotideActivity	DPM	0.0166666667	becquerel	\N	DPM = radioactive disintegrations per minute
disintegrationsPerMinutePerGram	disintegrationsPerMinutePerGram	t	radionucleotideActivity	DPM/g	\N	\N	\N	DPM/g = radioactive disintegrations per minute per gram of sample
fahrenheit	fahrenheit	f	\N	F	0.556	kelvin	-17.778	An obsolescent unit of temperature still used in popular meteorology
farad	farad	f	capacitance	F	1	\N	\N	farad
fathom	fathom	f	\N	\N	1.8288	meter	\N	6 feet
feetPerDay	feetPerDay	f	speed	ft/day	0.00000352778	metersPerSecond	\N	feet per day
feetPerHour	feetPerHour	f	speed	ft/hr	0.000084667	metersPerSecond	\N	feet per hour
feetPerSecond	feetPerSecond	f	speed	ft/s	0.3048	metersPerSecond	\N	feet per second
feetSquaredPerDay	feetSquaredPerDay	f	transmissivity	ft²/day	0.000124586	metersSquaredPerSecond	\N	feet squared per day
foot	foot	f	\N	ft	0.3048	meter	\N	12 inches
Foot_Gold_Coast	Foot_Gold_Coast	f	\N	gcft	0.3047997	meter	\N	12 inches
Foot_US	Foot_US	f	\N	usft	0.3048	meter	\N	12 inches
footPound	footPound	f	energy	\N	1.355818	joule	\N	1 ft-lbs = 1.355818 J
gallon	gallon	f	\N	gal	3.785412	liter	\N	US liquid gallon
grad	grad	f	angle	grad	0.015707	radian	\N	grad
gram	gram	f	mass	g	0.001	kilogram	\N	0.001 kg
gramsPerCentimeterSquaredPerSecond	gramsPerCentimeterSquaredPerSecond	f	arealMassDensityRate	\N	0.1	kilogramsPerMeterSquaredPerSecond	\N	grams Per Centimeter Squared Per Second
gramsPerCubicCentimeter	gramsPerCubicCentimeter	f	massDensity	g/cm³	1000	kilogramsPerCubicMeter	\N	grams per cubic centimeter
gramsPerGram	gramsPerGram	f	massPerMass	\N	1	\N	\N	grams per gram
gramsPerHectarePerDay	gramsPerHectarePerDay	f	arealMassDensityRate	\N	0.0000000000011574	kilogramsPerMeterSquaredPerSecond	\N	grams Per Hectare Squared Per Day
gramsPerLiter	gramsPerLiter	f	massDensity	g/l	1	kilogramsPerCubicMeter	\N	grams per liter
gramsPerLiterPerDay	gramsPerLiterPerDay	f	volumetricMassDensityRate	\N	1	\N	\N	grams Per (Liter Per Day)
gramsPerMeterSquaredPerHour	gramsPerMeterSquaredPerHour	t	arealMassDensityRate	g/m^2/hr	0.0000166667	kilogramsPerMeterSquaredPerSecond	\N	grams per meter square per hour
gramsPerMeterSquaredPerYear	gramsPerMeterSquaredPerYear	f	arealMassDensityRate	\N	0.0000000000317098	kilogramsPerMeterSquaredPerSecond	\N	grams Per Meter Squared Per Year
gramsPerMilliliter	gramsPerMilliliter	f	massDensity	g/ml	1000	kilogramsPerCubicMeter	\N	grams per milliliter
gramsPerSquareMeter	gramsPerSquareMeter	f	arealMassDensity	g/m²	0.001	kilogramsPerSquareMeter	\N	grams per square meter
gramsPerYear	gramsPerYear	f	massFlux	g/yr	0.0000000000317	kilogramsPerSecond	\N	grams Per Year
gray	gray	f	specificEnergy	Gy	1	\N	\N	gray
hectare	hectare	f	area	ha	10000	squareMeter	\N	1 hectare is 10^4 square meters
celsius	celsius	f	\N	C	1	kelvin	273.18	SI-derived unit of temperature
hectogram	hectogram	f	mass	hg	0.1	kilogram	\N	.1 kg
degree	degree	f	angle	°	0.0174532924	radian	\N	360 degrees comprise a unit circle.
gramPerOneQuarterMeterSquared	gramPerOneQuarterMeterSquared	t	arealMassDensity	g/0.25m^2	\N	\N	\N	Grams per 0.25 square meter surface area
hectometer	hectometer	f	\N	hm	100	meter	\N	100 meters
hectosecond	hectosecond	f	\N	hsec	100	second	\N	100 seconds
henry	henry	f	inductance	H	1	\N	\N	henry
hertz	hertz	f	frequency	Hz	1	\N	\N	hertz
hour	hour	f	\N	hr	3600	second	\N	3600 seconds
inch	inch	f	\N	in	0.0254	meter	\N	An imperial measure of length
joule	joule	f	energy	J	1	\N	\N	joule = N*m
katal	katal	f	catalyticActivity	kat	1	\N	\N	katal
kelvin	kelvin	f	temperature	K	1	\N	\N	SI unit of temperature
kilogram	kilogram	f	mass	kg	1	\N	\N	SI unit of mass
kilogramPerCubicMeter	kilogramPerCubicMeter	f	massDensity	\N	1	\N	\N	kilogram per cubic meter
kilogramsPerHectare	kilogramsPerHectare	f	arealMassDensity	\N	0.0001	kilogramsPerSquareMeter	\N	kilograms per hectare
kilogramsPerHectarePerYear	kilogramsPerHectarePerYear	f	arealMassDensityRate	\N	0.000317	kilogramsPerMeterSquaredPerSecond	\N	kilograms Per Hectare Per Year
kilogramsPerMeterSquaredPerSecond	kilogramsPerMeterSquaredPerSecond	f	arealMassDensityRate	\N	1	\N	\N	kilograms per meter sqared per second
kilogramsPerMeterSquaredPerYear	kilogramsPerMeterSquaredPerYear	f	arealMassDensityRate	\N	0000000317	kilogramsPerMeterSquaredPerSecond	\N	kilograms Per Meter Squared Per Year
kilogramsPerSecond	kilogramsPerSecond	f	massFlux	kg/s	1	\N	\N	kilograms per second
kilogramsPerSquareMeter	kilogramsPerSquareMeter	f	arealMassDensity	kg/m²	1	\N	\N	kilograms per square meter
kilohertz	kilohertz	f	frequency	KHz	1000	hertz	\N	kilohertz
kiloliter	kiloliter	f	volume	kL	1	cubicMeter	\N	1 cubic meter
kilometer	kilometer	f	\N	km	1000	meter	\N	1000 meters
kilometersPerHour	kilometersPerHour	f	speed	km/hr	0.2778	metersPerSecond	\N	km/hr
kilopascal	kilopascal	f	pressure	kPa	1000	pascal	\N	kilopascal
kilosecond	kilosecond	f	\N	ksec	1000	second	\N	1000 seconds
kilovolt	kilovolt	f	potentialDifference	kV	1000	volt	\N	kilovolt
kilowatt	kilowatt	f	power	kW	1000	watt	\N	kilowatt
knots	knots	f	speed	\N	0.514444	metersPerSecond	\N	knots
Link_Clarke	Link_Clarke	f	\N	\N	0.2011661949	meter	\N	This is an ESRI unit and the multiplier comes from ESRI. It may not be accurate.
liter	liter	f	volume	L	0.001	cubicMeter	\N	1000 cm^3
lumen	lumen	f	luminosity	lm	1	\N	\N	lumen
lux	lux	f	illuminance	lx	1	\N	\N	lux
megagram	megagram	f	mass	Mg	1000	kilogram	\N	1000 kg
megahertz	megahertz	f	frequency	MHz	1000000	hertz	\N	megahertz
megameter	megameter	f	\N	Mm	1000000	meter	\N	1000000 meters
megapascal	megapascal	f	pressure	MPa	1000000	pascal	\N	megapascal
megasecond	megasecond	f	\N	Msec	1000000	second	\N	1000000 seconds
megavolt	megavolt	f	potentialDifference	MV	1000000	volt	\N	megavolt
megawatt	megawatt	f	power	MW	1000000	watt	\N	megawatt
meter	meter	f	length	m	1	\N	\N	SI unit of length
metersPerDay	metersPerDay	f	speed	m/day	.0000115741	\N	\N	meters per day
metersPerGram	metersPerGram	f	massSpecificLength	m/g	1	\N	\N	meters per gram
metersPerSecond	metersPerSecond	f	speed	m/s	1	metersPerSecond	\N	meters per second
metersPerSecondSquared	metersPerSecondSquared	f	acceleration	m/s²	1	\N	\N	meters per second squared
metersSquaredPerDay	metersSquaredPerDay	f	transmissivity	m²/day	86400	metersSquaredPerSecond	\N	meters squared per day
metersSquaredPerSecond	metersSquaredPerSecond	f	transmissivity	m²/s	1	\N	\N	meters squared per second
microCuriePerMicroMole	microCuriePerMicroMole	t	radionucleotideActivity	µCi/µmol	1	\N	\N	specific activity of a radionuclide
microEinsteinsPerSquareMeter	microEinsteinsPerSquareMeter	t	illuminance	µE/m^2	1	\N	\N	micro Einsteins (1E-06 moles of photons) per square meter (radiant flux)
microEinsteinsPerSquareMeterPerSecond	microEinsteinsPerSquareMeterPerSecond	t	illuminance	µE/m^2/s	1	\N	\N	micro Einsteins (1E-06 moles of photons) per square meter per second (radiant flux density)
microgram	microgram	f	mass	µg	0.000000001	kilogram	\N	0.000000001 kg
microgramsPerGram	microgramsPerGram	f	massPerMass	\N	0.000001	gramsPerGram	\N	micrograms per gram
microgramsPerLiter	microgramsPerLiter	f	massDensity	µg/l	0.000001	kilogramsPerCubicMeter	\N	micrograms / liter
microgramsPerMilligram	microgramsPerMilligram	t	massPerMass	ug/mg	0.001	gramsPerGram	\N	micrograms per milligram
microgramsPerMilliliter	microgramsPerMilliliter	t	massDensity	µg/ml	0.000001	gramsPerMilliliter	\N	micrograms per milliliter
microliter	microliter	f	volume	µl	0.000000001	cubicMeter	\N	1/1000000 of a liter
micrometer	micrometer	f	\N	µm	0.000001	meter	\N	.000001 meters
microMolesPerKilogram	microMolesPerKilogram	t	amountOfSubstanceConcentration	µmol/kg	1	\N	\N	µmol/kg = µmoles per kilogram of substance
micron	micron	f	\N	µ	0.000001	meter	\N	.000001 meters
microsecond	microsecond	f	\N	µsec	0.000001	second	\N	1/100000 of a second
mile	mile	f	\N	mile	1609.344	meter	\N	5280 ft or 1609.344 meters
milesPerHour	milesPerHour	f	speed	mph	0.44704	metersPerSecond	\N	miles per hour
milesPerMinute	milesPerMinute	f	speed	mpm	26.8224	metersPerSecond	\N	miles per minute
milesPerSecond	milesPerSecond	f	speed	mps	1609.344	metersPerSecond	\N	miles per second
millibar	millibar	f	pressure	mbar	100	pascal	\N	millibar
milligram	milligram	f	mass	mg	0.000001	kilogram	\N	0.000001 kg
milligramsPerCubicMeter	milligramsPerCubicMeter	f	massDensity	mg/m³	0.000001	kilogramsPerCubicMeter	\N	milligrams Per Cubic Meter
milligramsPerLiter	milligramsPerLiter	f	massDensity	mg/l	0.001	kilogramsPerCubicMeter	\N	milligrams / liter
literPerSquareMeter	literPerSquareMeter	f	volumetricArea	l/m²	1	\N	\N	liters per square meter
milliGramsPerMilliLiter	milliGramsPerMilliLiter	f	massDensity	kg/m³	1	kilogramsPerCubicMeter	\N	milligrams per milliliter
milligramsPerSquareMeter	milligramsPerSquareMeter	f	arealMassDensity	mg/m²	0.000001	kilogramsPerSquareMeter	\N	milligrams Per Square Meter
millihertz	millihertz	f	frequency	mHz	0.000001	hertz	\N	millihertz
milliliter	milliliter	f	volume	ml	0.000001	cubicMeter	\N	1/1000 of a liter
milliliterPerLiter	milliliterPerLiter	t	volumePerVolume	ml/L	1	\N	\N	milliters of solution per total volume
millimeter	millimeter	f	\N	mm	0.001	meter	\N	.001 meters
millimetersPerSecond	millimetersPerSecond	f	speed	mm/s	0.001	metersPerSecond	\N	millimeters per second
millimolesPerGram	millimolesPerGram	f	amountOfSubstanceWeight	\N	1	molesPerKilogram	\N	millimoles per gram
millimolesPerSquareMeterPerHour	millimolesPerSquareMeterPerHour	t	amountOfSubstanceWeightFlux	mmol/m^2/hr	1	\N	\N	millimoles per square meter per hour (areal flux or diffusion of a substance)
millisecond	millisecond	f	\N	msec	0.001	second	\N	1/1000 of a second
millivolt	millivolt	f	potentialDifference	mV	0.001	volt	\N	millivolt
milliwatt	milliwatt	f	power	mW	0.001	watt	\N	milliwatt
minute	minute	f	\N	min	60	second	\N	60 seconds
molality	molality	f	amountOfSubstanceWeight	m	1	\N	\N	molality = moles/kg
molarity	molarity	f	amountOfSubstanceConcentration	M	1000	molesPerCubicMeter	\N	molarity = moles/liter
mole	mole	f	amount	mol	1	\N	\N	SI unit of substance amount
molePerCubicMeter	molePerCubicMeter	f	amountOfSubstanceConcentration	\N	1	\N	\N	mole per cubic meter
molesPerGram	molesPerGram	f	amountOfSubstanceWeight	\N	1000	molesPerKilogram	\N	moles per gram
molesPerKilogram	molesPerKilogram	f	amountOfSubstanceWeight	\N	1	\N	\N	moles per kilogram
molesPerKilogramPerSecond	molesPerKilogramPerSecond	f	amountOfSubstanceWeightFlux	\N	1	\N	\N	moles per kilogram per second
nanogram	nanogram	f	mass	ng	0.000000000001	kilogram	\N	0.000000000001 kg
nanometer	nanometer	f	\N	nm	0.000000001	meter	\N	.000000001 meters
nanomolesPerGramPerSecond	nanomolesPerGramPerSecond	f	amountOfSubstanceWeightFlux	\N	0.000001	molesPerKilogramPerSecond	\N	nanomoles Per Gram Per Second
nanosecond	nanosecond	f	\N	nsec	0.000000001	second	\N	1/1000000 of a second
nauticalMile	nauticalMile	f	\N	\N	1852	meter	\N	nautical mile
newton	newton	f	force	N	1	\N	\N	newton
nominalDay	nominalDay	f	time	\N	86400	second	\N	one day excluding leap seconds, 86400 seconds
nominalHour	nominalHour	f	time	\N	3600	second	\N	one hour excluding leap seconds, 3600 seconds
nominalLeapYear	nominalLeapYear	f	time	\N	31622400	second	\N	one 366 day year excluding leap seconds, 31622400 seconds
nominalMinute	nominalMinute	f	time	\N	60	second	\N	one minute excluding leap seconds, 60 seconds
nominalWeek	nominalWeek	f	time	\N	604800	second	\N	one day excluding leap seconds, 604800 seconds
nominalYear	nominalYear	f	time	\N	31536000	second	\N	one year excluding leap seconds and leap days, 31536000 seconds
numberPerGram	numberPerGram	f	massSpecificCount	\N	1	\N	\N	number of entities per gram
numberPerKilometerSquared	numberPerKilometerSquared	f	arealDensity	\N	0.000001	numberPerMeterSquared	\N	number per kilometer squared
numberPerMeterCubed	numberPerMeterCubed	f	volumetricDensity	\N	1	\N	\N	number per meter cubed
numberPerMeterSquared	numberPerMeterSquared	f	arealDensity	\N	1	\N	\N	number per meter squared
numberPerMilliliter	numberPerMilliliter	t	volumetricDensity	number/ml	1	\N	\N	number of particles or organisms per milliliter of solution
numberPerSquareCentimeterPerHour	numberPerSquareCentimeterPerHour	t	frequency	number/cm^2/hr	1	\N	\N	rate of change of areal density of a substance (e.g. growth or expulsion rate)
ohm	ohm	f	resistance	O	1	\N	\N	ohm
ohmMeter	ohmMeter	f	resistivity	Om	1	\N	\N	ohm meters
partsPerMillion	partsPerMillion	t	dimensionless	ppm	1	\N	\N	ratio of two quantities as parts per million (1:1000000)
partsPerThousand	partsPerThousand	t	dimensionless	ppt	1	\N	\N	ratio of two quantities as parts per thousand (1:1000)
pascal	pascal	f	pressure	Pa	1	\N	\N	pascal
percent	percent	t	dimensionless	%	1	\N	\N	ratio of two quantities as percent composition (1:100)
picoCuriesPerGram	picoCuriesPerGram	t	radionucleotideActivity	pCi/g	\N	\N	\N	pCi/g = 1E-12 Curies per gram of sample, equal to 2.22 radioactive disintegrations per minute per gram of sample
picoMolesPerLiter	picoMolesPerLiter	t	amountOfSubstanceConcentration	pM	0.000000000001	molarity	\N	picomoles per liter of solution
picoMolesPerLiterPerHour	picoMolesPerLiterPerHour	t	amountOfSubstanceWeightFlux	pmol/L/hr	1	\N	\N	picomoles per liter of solution per hour (concentration flux)
pint	pint	f	\N	pint	0.473176	liter	\N	US liquid pint
pound	pound	f	\N	lbs	0.4536	kilogram	\N	1 pound in the Avoirdupois (commerce) scale
poundsPerSquareInch	poundsPerSquareInch	f	arealMassDensity	lbs/in²	17.85	kilogramsPerSquareMeter	\N	lbs/square inch
quart	quart	f	\N	qt	0.946353	liter	\N	US liquid quart
radian	radian	f	angle	rad	1	\N	\N	2 pi radians comprise a unit circle.
second	second	f	time	sec	1	\N	\N	SI unit of time
serialDateNumberYear0000	serialDateNumberYear0000	t	dimensionless	\N	1	\N	\N	fractional days representing a serial date number based on 1 = 1-Jan-0000
siemen	siemen	f	conductance	S	1	\N	\N	siemen
siemensPerMeter	siemensPerMeter	t	conductance	S/m	1	\N	\N	siemens per meter (electrolytic conductivity of a solution)
sievert	sievert	f	doseEquivalent	Sv	1	\N	\N	sievert
squareCentimeters	squareCentimeters	f	area	\N	0.0001	squareMeter	\N	square centimeters
squareFoot	squareFoot	f	area	ft²	0.092903	squareMeter	\N	12 inches squared
squareKilometers	squareKilometers	f	area	\N	1000000	squareMeter	\N	square kilometers
squareMeter	squareMeter	f	area	m²	1	\N	\N	square meters
squareMeterPerKilogram	squareMeterPerKilogram	f	specificArea	m²/kg	1	\N	\N	square meters per kilogram
squareMile	squareMile	f	area	mile²	2589998.49806	squareMeter	\N	1 mile squared
squareMillimeters	squareMillimeters	f	area	\N	0.000001	squareMeter	\N	square millmeters
squareYard	squareYard	f	area	yd²	0.836131	squareMeter	\N	36 inches squared
tesla	tesla	f	magneticFluxDensity	T	1	\N	\N	tesla
ton	ton	f	\N	ton	907.1999	kilogram	\N	standard US (short) ton = 2000 lbs
tonne	tonne	f	mass	T	1000	kilogram	\N	metric ton or tonne
tonnePerHectare	tonnePerHectare	f	arealMassDensity	\N	0.1	kilogramsPerSquareMeter	\N	metric ton or tonne per hectare
tonnesPerYear	tonnesPerYear	f	massFlux	\N	0.0000317	kilogramsPerSecond	\N	tonnes Per Year
volt	volt	f	potentialDifference	V	1	\N	\N	volt
watt	watt	f	power	W	1	\N	\N	watt = J/s
waveNumber	waveNumber	f	lengthReciprocal	\N	1	\N	\N	1/meters
weber	weber	f	magneticFlux	Wb	1	\N	\N	weber
yard	yard	f	\N	yard	0.9144	meter	\N	3 feet
Yard_Indian	Yard_Indian	f	\N	\N	0.914398530744440774	meter	\N	This is an ESRI unit and the multiplier comes from ESRI. It may not be accurate.
Yard_Sears	Yard_Sears	f	\N	\N	0.91439841461602867	meter	\N	This is an ESRI unit and the multiplier comes from ESRI. It may not be accurate.
yardsPerSecond	yardsPerSecond	f	speed	yd/s	0.9144	metersPerSecond	\N	yards per second
angstrom	angstrom	f	\N	\N	0.0000000001	meter	\N	1/10000000000 meter
meterSquared	meterSquared	t	area	m2	1	meter	0	area, meter squared from the LTER unit dictionary
numberPerLiter	numberPerLiter	t	volumetricDensity		0.001	numberPerMeterCubed	0	number of entities per liter
gramPerMeterCubed	gramPerMeterCubed	t	massDensity	g m-3	0.001	kilogramPerMeterCibed	0	gram per cubic meter
gramPerMeterSquared	gramPerMeterSquared	t	arealMassDensity	g/m2	0.001	kilogramsPerSquareMeter	0	grams per square meter
kilogramPerMeterSquared	kilogramPerMeterSquared	f	arealMassDensity	kg/m2	1	kilogramPerMeterSquared	\N	kilograms per square meter
kilogramPerMeterCubed	kilogramPerMeterCubed	f	massDensity	kg/m3	1	kilogramPerMeterCubed	\N	kilograms per cubit meter
micromolePerMeterSquared	micromolePerMeterSquared	f	amountOfSubstanceConcentration	umol/m2	0.000001	molePerMeterSquared	1	commonly used for integrated concentration of chemical constituents in natural water bodies
permil	permil	t	dimensionless	o/oo	0.001	\N	0	permil is a shorthand way of saying parts per thousand parts. values must have the same dimensions.
picomolePerLiterPerHour	picomolePerLiterPerHour	t	amountOfSubstanceWeightFlux	pmol/L/hr	\N	\N	\N	picomoles per liter of solution per hour (concentration flux)
hectoPascal	hectoPascal	t	pressure	hPa	\N	pascal	\N	SI unit for atmospheric pressure, equivalent in magnitude to millibar
reciprocalDay	reciprocalDay	t	timeReciprocal	day^-1	\N	second	\N	per day, specific growth rate
reciprocalMeterPerSteradian	reciprocalMeterPerSteradian	t	lengthReciprocal	m-1 sr-1	\N	meterPerSteradian	\N	describes directional optical measurements
reciprocalMeter	reciprocalMeter	t	lengthReciprocal	m-1	\N	meter	\N	per meter, describes optical properties
microwattPerSquareCentimeterPerNanometer	microwattPerSquareCentimeterPerNanometer	t	power	\N	\N	joule	\N	irradiance unit
wattPerMeterSquared	wattPerMeterSquared	t	power	\N	\N	\N	\N	irradiance unit
microwattPerCentimeterSquaredPerNanometerPerSteradian	microwattPerCentimeterSquaredPerNanometerPerSteradian	t	power	\N	\N	joule	\N	directional irradiance unit
milligramPerMeterCubed	milligramPerMeterCubed	t	volumetricMassDensity	\N	\N	kilogramPerMeterCubed	0	concentration unit, sometimes used for pigments in natural waters.same magnitude as microgramPerLiter
milligramPerMeterCubedPerDay	milligramPerMeterCubedPerDay	t	volumetricMassDensityRate	mg m-3 d-1	\N	kilogramPerMeterCubedPerSecond	0	a volumetric flux unit. often used for a primary production rate, e.g., for a parcel of water. Often is specific to an element, e.g., carbon
micromolePerLiter	micromolePerLiter	t	amountOfSubstanceConcentration	\N	\N	molePerMeterCubed	0	commonly used for concentration of some chemical constituents of natural water bodies, e.g., nutrients. It has the same magnitude as micromolar, but micromolar can only be used for a dissolved constituent
milligramPerLiter	milligramPerLiter	t	volumetricMassDensity	\N	\N	kilogramPerCubicMeter	0	concentration unit, sometimes used for pigments in natural waters
microgramPerLiter	microgramPerLiter	t	\N	\N	\N	gramPerMeterCubed	0	concentration unit. Based on the dimensions (mass/volume), the unitType is probably density, but this would be misleading, so it is left NULL here.
microeinsteinPerMeterSquaredPerSecond	microeinsteinPerMeterSquaredPerSecond	t	energy	\N	\N	joule	\N	PAR irradiance unit, Seabird 911. 1Ein = energy of 1 mole photons
microeinsteinPerCentimeterSquaredPerSecond	microeinsteinPerCentimeterSquaredPerSecond	t	energy	\N	\N	joule	\N	PAR irradiance unit, 1Ein = energy of 1 mole photons
kilogramPerMeterSquaredPerDay	kilogramPerMeterSquaredPerDay	t	areaMassDensityRate	kg m-2 d-1	\N	kilogramPerMeterCubed	0	areal primary production rate, may apply to DW, or to element content, e.g., Carbon or Nitrogen"
inchesMercury	inchesMercury	t	pressure	inHg	\N	inch	\N	old unit for atmospheric pressure
siemensPerCentimeter	siemensPerCentimeter	t	conductance	\N	\N	siemensPerMeter	0	conductivity unit, seawater, A siemems is equal to one ampere per volt.
microequivalentPerLiter	microequivalentPerLiter	t	amountOfSubstanceConcentration	\N	\N	molesPerMeterCubed	0	concentration of charge (on dissolved ions). A single ultiplier to SI is not possible, since conversion includes valence of ion, which can vary
micromolePerKilogram	micromolePerKilogram	t	\N	\N	\N	molePerKilogram	0	a concentration unit used in oceanography. volume changes with depth, but mass does not. Not sure what the unitType should be.
milligramPerMeterSquaredPerDay	milligramPerMeterSquaredPerDay	t	areaMassDensityRate	mg m-2 d-1	\N	kilogramPerMeterSquaredPerSecond	0	an areal flux unit. often used for a primary production rate, e.g., for an integrated water column. May have context of dry weight, or specific to an element, e.g., carbon
millimolePerMeterSquaredPerHour	millimolePerMeterSquaredPerHour	t	\N	mmol m-2 h-1	\N	molePerMeterSquaredPerSecond	0	an areal flux unit. 
molePerMeterSquaredPerDay	molePerMeterSquaredPerDay	t	\N	mmol m-2 h-1	\N	molePerMeterSquaredPerSecond	0	an areal flux unit, moles (of an element) per day.
millimolePerMeterCubed	millimolePerMeterCubed	t	\N	mmol m-2 h-1	\N	molePerMeterCubed	0	a concentration unit..
numberPerNumber	numberPerNumber	t	numberPerNumber		\N	gramsPerGram	\N	ratio with no scaling,
microgramPerMeterSquared	microgramPerMeterSquared	f	arealDensity	ug/m2	0.000000001	kilogramPerMeterSquared	1	used for integrated concentration of chemical constituents when measuered by weight, eg, pigments.
micromolePerMeterSquaredPerDay	micromolePerMeterSquaredPerDay	f	amountOfSubstanceWeightFlux	umol/m2/day	0.000001	molePerMeterSquaredPerDay	1	areal uptake rate
micromolePerMeterSquaredPerSecond	micromolePerMeterSquaredPerSecond	f	amountOfSubstanceWeightFlux	umol/m2/sec	0.000001	molePerMeterSquaredPerSecond	1	areal flux rate
biomassDensityUnitPerAbundanceUnit	biomassDensityUnitPerAbundanceUnit	f	\N	\N	\N	\N	\N	a ratio of two other units
milligramPerMeterSquaredPerHourPerGram	milligramPerMeterSquaredPerHourPerGram	f	\N	\N	\N	\N	\N	specifc areal flux rate
productionRatePerGramPerIrradiance	productionRatePerGramPerIrradiance	f	\N	\N	\N	\N	\N	slope of a PI curve
gramPerMeterSquaredPerDay	gramPerMeterSquaredPerDay	f	massFlux	g/m2/day	\N	\N	\N	\N
literPerHectare	literPerHectare	f	volumetricArea	\N	0.0001	litersPerSquareMeter	\N	liters per hectare
literPerSecond	literPerSecond	f	volumetricRate	l/s	1	\N	\N	liters per second
centimeterPerSecond	centimeterPerSecond	f	speed	cm/s	0.01	metersPerSecond	\N	centimeters per second
gramPerGram	gramPerGram	f	massPerMass	g/g	\N	\N	\N	\N
meterPerSecond	meterPerSecond	f	speed	m/s	\N	\N	\N	\N
kilometerSquared	kilometerSquared	f	area	\N	\N	\N	\N	\N
numberPer85CentimeterSquaredPerDay	numberPer85CentimeterSquaredPerDay	t	arealDensityRate	\N	\N	\N	\N	number of organisms (things) per area of 85 cm squared per day
number	number	f	dimensionless	\N	\N	\N	\N	a number
dimensionless	dimensionless	f	dimensionless	\N	\N	\N	\N	a designation asserting the absence of an associated unit
acre	acre	f	area	a	4046.8564	squareMeter	\N	1 acre = 4046.8564 square meters or 1 hectare = 2.4710 acres
TODO	TODO	t	\N	TODO	TODO	TODO	TODO	TODO
millimolePerMeterSquaredPerDay	millimolePerMeterSquaredPerDay	t	\N	mmol/m^2/day	1	mole	0	millimole per square meter per day
milliMolesPerKilogram	milliMolesPerKilogram	t	amountOfSubstanceConcentration	mmol/kg	1	\N	\N	mmol/kg = millimoles per kilogram of substance. used in seawater to factor out changes in volume with depth.
centimeterSquared	centimeterSquared	f	area	cm2	.0001	meterSquared	\N	\N
becquerelPerLiter	becquerelPerLiter	f	radioactivity	Bq/L	0.000001	becquerelPerMeterCubed	\N	One Becquerel (Bq) is defined as the activity of a quantity of radioactive material in which one nucleus decays per second. The Bq unit is therefore equivalent to an inverse second, s^1.  (Wikipedia)
microatmosphere	microatmosphere	t	pressure	microatm	0.101325	pascal	0	1 microAtmosphere = 0.000001 atmospheres = 1013.25 millibars = 0.101325 Pascals = 0.0000147 lb/sq.in
milligramPerCentimeterSquared	milligramPerCentimeterSquared	f	arealMassDensity	mg/cm2	0.01	kilogramPerMeterSquared	\N	\N
microgramPerCentimeterSquared	microgramPerCentimeterSquared	f	arealMassDensity	ug/cm2	0.0001	kilogramPerMeterSquared	\N	\N
numberPerMicroliter	numberPerMicroliter	t	volumetricDensity	number/ul	1	\N	\N	number of particles or organisms per microliter of solution
micromolePerCentimeterSquaredPerHourPerPhotonFlux	micromolePerCentimeterSquaredPerHourPerPhotonFlux	t	arealDensityRate	(umol cm-2 h-1)/(umol m-2 s-1)	\N	molePerMeterSquaredPerSecond	0	an areal flux unit. often used for a primary production rate, e.g., for a sample of plant tissue. May have context of dry weight, or specific to an element, e.g., carbon
kilogramPerHour	kilogramPerHour	f	massFlux	kg/hr	1	\N	\N	kilograms per hour
millisiemensPerMeter	millisiemensPerMeter	f	conductance	mS/m	0.001	siemensPerMeter	0	asdfasdfasdfasdfasdf
gramPerCentimeterSquared	gramPerCentimeterSquared	t	arealMassDensity	g/cm2	0.0000001	kilogramsPerSquareMeter	0	grams per square centimeter
kilogramPerHourPerPerson	kilogramPerHourPerPerson	f	\N	kg/hr/person	1	\N	\N	kilograms per hour, per person, eg, person performing work 
milligramPerGramPerHour	milligramPerGramPerHour	f	\N	mg g-1 h-1	.001	kilogramPerKilogramPerHour	\N	mass-specific rate
micromolePerCentimeterSquaredPerHour	micromolePerCentimeterSquaredPerHour	t	arealDensityRate	umol cm-2 h-1	\N	molePerMeterSquaredPerSecond	0	an areal flux unit. often used for a primary production rate, e.g., for a sample of plant tissue. May have context of dry weight, or specific to an element, e.g., carbon
milligramPerGramPerHourPerPhotonFlux	milligramPerGramPerHourPerPhotonFlux	f	\N	(mg g-1 h-1)/(umol m-2 s-1)	.001	kilogramPerKilogramPerHourPerPhotonFlux	\N	flux-specific mass-specific rate
gramPerOneTenthMeterSquared	gramPerOneTenthMeterSquared	t	arealMassDensity	g/0.1m^2	\N	\N	\N	Grams per 0.1 square meter surface area
metricTon	metricTon	f	mass	T	1000	kilogram	\N	metric ton or tonne
microMolesPerGramPerHour	microMolesPerGramPerHour	t	amountOfSubstanceWeightFlux	µmol/g/h	0.000000001	molePerKilogramPerHour	\N	µmol/g/h= µmoles per gram of substance per hour
microMolesPerLiterPerHour	microMolesPerLiterPerHour	t	amountOfSubstanceWeightFlux	µmol/l/h	0.000001	molePerLiterPerHour	\N	µmol/l/h = µmoles per liter of solution per hour
microMolesPerLiter	microMolesPerLiter	t	amountOfSubstanceConcentration	µM/l	0.000001	\N	\N	µM = µmoles per liter of solution
kilogramPerDay	kilogramPerDay	t	massFlux	kg/day	1	\N	\N	kilograms per day
numberPerDay	numberPerDay	t	massPerMassRate	number/day	1	\N	\N	rate per day
kilogramPerMole	kilogramPerMole	f	\N	Kg/mol	1	\N	\N	kilogram per mole
\.



--
-- TOC entry 3189 (class 0 OID 130303)
-- Dependencies: 193
-- Data for Name: FileTypeList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."FileTypeList" ("FileType", "TypeName", "FileFormat", "Extension", "Description", "Delimiters", "Header", "EML_FormatType", "RecordDelimiter", "NumHeaderLines", "NumFooterLines", "AttributeOrientation", "QuoteCharacter", "FieldDelimiter", "CharacterEncoding", "CollapseDelimiters", "LiteralCharacter", "externallyDefinedFormat_formatName", "externallyDefinedFormat_formatVersion") FROM stdin;
csv_C	CSV unix, hdr, ftr	comma separated values	csv	CSV. unix line ending, 1-line header, 1-line footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\n	1	1	column	"	,	\N	no	\\	\N	\N
csv_D	CSV ms, hdr, no ftr	comma separated values	csv	CSV. ms line ending, 1-line header, no footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\r\\n	1	0	column	"	,	\N	no	\\	\N	\N
csv_E	CSV ms,  hdr, ftr	comma separated values	csv	CSV. ms line ending, 1-line header, 1-line footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\r\\n	1	1	column	"	,	\N	no	\\	\N	\N
excel_A	MS-Excel file, xlsx extension	MS-Excel	xslx	readable by several versions, eg available 2009 - 2015	not applicable	not applicable	externallyDefinedFormat	\N	\N	\N	column	\N	\N	\N	\N	\N	MS-Excel	\N
gif_A	GIF type A	GIF image	gif	GIF image	not applicable	not applicable	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	GIF	\N
mov_A	Movie, type A	MOV	mov	QuickTime movie	not applicable	none	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	QuickTime movie	\N
netcdf	NetCDF type	NetCDF file	nc	self-describing, machine-independent data formats and it was developed at the Unidata Program Center in Boulder, Colorado.	not applicable	none	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	NetCDF	\N
png_A	PNG type A	PNG	png	PNG image	not applicable	none	externallyDefinedFormat	\N	\N	\N	\N	\N	\N	\N	\N	\N	PNG	\N
csv_A	CSV unix, no hdr, no ftr	comma separated values	csv	CSV. unix line ending, no header, no footer, optional quoted strings and literal chars.	single comma	none	textFormat	\\n	0	0	column	"	,	\N	no	\\	\N	\N
csv_B	CSV unix, hdr, no ftr	comma separated values	csv	CSV. unix line ending, 1-line header, no footer, optional quoted strings and literal chars.	single comma	column names	textFormat	\\n	1	0	column	"	,	\N	no	\\	\N	\N
csv_F	CSV unix, 2-ln-hdr, no ftr	comma separated values	csv	CSV. unix line ending, 2-line header (table-specific), no footer, optional quoted strings and literal chars.	single comma	table-specific	textFormat	\\n	2	0	column	"	,	\N	no	\\	\N	\N
csv_G	CSV unix, 6-ln-hdr, no ftr	comma separated values	csv	CSV. unix line ending, 6-line header (table-specific), no footer, optional quoted strings and literal chars.	single comma	table-specific	textFormat	\\n	6	0	column	"	,	\N	no	\\	\N	\N
csv_H	CSV slash-r, hdr	comma-sep, mac line ending	csv	slash-r used by old macs (OS-9 and earlier)	single comma	column names	textFormat	\\r	1	0	column	"	,	\N	no	\\	\N	\N
mat_A	MATLAB type	MATLAB formatted data	mat	Partial access of variables in MATLAB workspace or saved MATLAB workspace	not applicable	none	externallyDefinedFormat	\N	\N	\N	column	\N	\N	\N	\N	\N	MATLAB	\N
txt_A	TXT type A	text file	txt	text file, unix line-ending, space-separated, collapse yes, hex code in EML, no header, no footer, optional quoted strings and literal chars.	space (hex code), collapse multiple.	none	textFormat	\\n	0	\N	column	"	#x20	\N	yes	\\	\N	\N
txt_B	TXT type B	text file	txt	ODV format: text file, unix line-ending, semicolon-separated, 1-line header, no footer, optional quoted strings and literal chars.	single semicolon	column names	textFormat	\\n	1	\N	column	"	;	\N	no	\\	\N	\N
txt_C	TXT type C	text file	txt	txt, tab-delimited. microsoft line ending, 1-line header, no footer, optional quoted strings and literal chars.	tab	column names	textFormat	\\r\\n	1	\N	column	"	\\t	\N	no	\\	\N	\N
txt_D	TXT type D	text file, moorings as of 2014	txt	resembles txt_A, but has a one line header	single space	column names	textFormat	\\n	1	\N	column	"	#x20	\N	yes	\\	\N	\N
txt_E	TXT type E	text file	txt	text file, unix line-ending, tab-separated, collapse yes, 1-line header, no footer, optional quoted strings and literal chars.	tab	column names	textFormat	\\n	1	\N	column	"	\\t	\N	yes	\\	\N	\N
\.


--
-- TOC entry 3190 (class 0 OID 130311)
-- Dependencies: 194
-- Data for Name: KeywordThesaurus; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."KeywordThesaurus" ("ThesaurusID", "ThesaurusLabel", "ThesaurusUrl", "UseInMetadata", "ThesaurusSortOrder") FROM stdin;
dwc	Darwin Core Terms	\N	t	100
ea	Ecological Archives	\N	t	90
ebv	Essential Biodiversity Variables	\N	t	80
gcmd6	Global Change Master Directory (GCMD) v6.0.0.0.0	\N	t	50
knb	Knowledge Network for Biocomplexity	\N	t	60
nbii	NBII Biocomplexity	\N	t	80
none	\N	\N	t	110
lter_cv	LTER Controlled Vocabulary v1	\N	t	20
lter_cv_cra	LTER Core Research Areas	\N	t	10
\.


/* 
 * removed
 * sbclter	SBC-LTER Controlled Vocabulary	\N	t	30
 * sbclter_place	Santa Barbara Coastal LTER Places	\N	t	40
 * 
 */
--
-- TOC entry 3191 (class 0 OID 130318)
-- Dependencies: 195
-- Data for Name: Keywords; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."Keywords" ("Keyword", "ThesaurusID", "KeywordType") FROM stdin;
abundance	lter_cv	theme
acidity	lter_cv	theme
Air Temperature	lter_cv	theme
algae	lter_cv	theme
alkalinity	lter_cv	theme
ammonium	lter_cv	theme
aquatic invertebrates	lter_cv	theme
Atmospheric Pressure	lter_cv	theme
benthic	lter_cv	theme
biomass	lter_cv	theme
canopy	lter_cv	theme
carbon	lter_cv	theme
carbon dioxide	lter_cv	theme
carbon to nitrogen ratio	lter_cv	theme
chemistry	lter_cv	theme
chlorophyll	lter_cv	theme
chlorophyll a	lter_cv	theme
Climate	lter_cv	theme
community composition	lter_cv	theme
community dynamics	lter_cv	theme
community patterns	lter_cv	theme
community respiration	lter_cv	theme
community structure	lter_cv	theme
crabs	lter_cv	theme
CTD	lter_cv	theme
depth	lter_cv	theme
detritus	lter_cv	theme
Dew point	lter_cv	theme
dissolved inorganic carbon	lter_cv	theme
dissolved organic carbon	lter_cv	theme
distribution	lter_cv	theme
ecosystem ecology	lter_cv	theme
endangered species	lter_cv	theme
fertilization	lter_cv	theme
fishes	lter_cv	theme
forests	lter_cv	theme
Freshwater	lter_cv	theme
gastropods	lter_cv	theme
genetics	lter_cv	theme
growth	lter_cv	theme
herbivores	lter_cv	theme
humans	lter_cv	theme
hydrology	lter_cv	theme
incubation	lter_cv	theme
invertebrates	lter_cv	theme
irradiance	lter_cv	theme
kelp	lter_cv	theme
larvae	lter_cv	theme
length	lter_cv	theme
light	lter_cv	theme
long term	lter_cv	theme
long term ecological research	lter_cv	theme
LTER	lter_cv	theme
macroalgae	lter_cv	theme
macroinvertebrates	lter_cv	theme
marine	lter_cv	theme
mass	lter_cv	theme
measurements	lter_cv	theme
mollusks	lter_cv	theme
Moorea Coral Reef LTER	lter_cv	theme
net primary production	lter_cv	theme
nitrate	lter_cv	theme
nitrite	lter_cv	theme
nitrogen	lter_cv	theme
nutrients	lter_cv	theme
oceans	lter_cv	theme
organism	lter_cv	theme
oxygen	lter_cv	theme
particulate organic carbon	lter_cv	theme
percent cover	lter_cv	theme
pH	lter_cv	theme
phosphate	lter_cv	theme
phosphorus	lter_cv	theme
photosynthesis	lter_cv	theme
photosynthetically active radiation	lter_cv	theme
phytoplankton	lter_cv	theme
population dynamics	lter_cv	theme
populations	lter_cv	theme
precipitation	lter_cv	theme
predation	lter_cv	theme
predators	lter_cv	theme
productivity	lter_cv	theme
respiration	lter_cv	theme
salinity	lter_cv	theme
sand	lter_cv	theme
Santa Barbara Coastal	lter_cv	theme
seasonality	lter_cv	theme
seawater	lter_cv	theme
size	lter_cv	theme
soluble reactive phosphorus	lter_cv	theme
spatial variability	lter_cv	theme
species	lter_cv	theme
species composition	lter_cv	theme
stage height	lter_cv	theme
standing crop	lter_cv	theme
stream discharge	lter_cv	theme
streams	lter_cv	theme
surveys	lter_cv	theme
temperature	lter_cv	theme
terrestrial	lter_cv	theme
total nitrogen	lter_cv	theme
total phosphorus	lter_cv	theme
transects	lter_cv	theme
trophic dynamics	lter_cv	theme
trophic structure	lter_cv	theme
water	lter_cv	theme
wind	lter_cv	theme
wind direction	lter_cv	theme
wind speed	lter_cv	theme
disturbance	lter_cv_cra	theme
Disturbance Patterns	lter_cv_cra	theme
inorganic matter and flux	lter_cv_cra	theme
inorganic nutrients	lter_cv_cra	theme
organic matter	lter_cv_cra	theme
populations	lter_cv_cra	theme
primary production	lter_cv_cra	theme
\.


--
-- TOC entry 3192 (class 0 OID 130322)
-- Dependencies: 196
-- Data for Name: MeasurementScaleDomains; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

COPY lter_metabase."MeasurementScaleDomains" ("EMLDomainType", "MeasurementScale", "NonNumericDomain", "MeasurementScaleDomainID") FROM stdin;
dateTimeDomain	dateTime		dateTime
numericDomain	interval		interval
nonNumericDomain	nominal	enumeratedDomain	nominalEnum
nonNumericDomain	nominal	textDomain	nominalText
nonNumericDomain	ordinal	enumeratedDomain	ordinalEnum
nonNumericDomain	ordinal	textDomain	ordinalText
numericDomain	ratio		ratio
\.


--
-- TOC entry 3172 (class 0 OID 130212)
-- Dependencies: 176
-- Data for Name: People; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3173 (class 0 OID 130218)
-- Dependencies: 177
-- Data for Name: Peopleidentification; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3193 (class 0 OID 130325)
-- Dependencies: 197
-- Data for Name: ProtocolList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--

--
-- TOC entry 3194 (class 0 OID 130331)
-- Dependencies: 198
-- Data for Name: SiteList; Type: TABLE DATA; Schema: lter_metabase; Owner: %db_owner%
--


--
-- TOC entry 3168 (class 0 OID 130196)
-- Dependencies: 172
-- Data for Name: cv_cra; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_cra (cra_id, cra_name) FROM stdin;
pp	Primary Production 
om	Movement of Organic Matter
dp	Disturbance Patterns
pd	Population Dynamics
in	Movement of Inorganic Nutrients 
\.


--
-- TOC entry 3195 (class 0 OID 130387)
-- Dependencies: 209
-- Data for Name: cv_mgmt_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_mgmt_type (mgmt_type, definition) FROM stdin;
templated	\N
non_templated	\N
\.


--
-- TOC entry 3196 (class 0 OID 130393)
-- Dependencies: 210
-- Data for Name: cv_network_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_network_type (network_type, definition) FROM stdin;
0	data usage is controlled by a group other than the local LTER
I	data are publicly available
II	data are restricted and available upon request
mix	at least one entity in the dataset is of each type I and II
NA	network types do not apply. this dataset (EML record) does not go to the network, e.g., it's a template.
\.


--
-- TOC entry 3197 (class 0 OID 130399)
-- Dependencies: 211
-- Data for Name: cv_spatial_extent; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatial_extent (spatial_extent, definition) FROM stdin;
lab	data are from an experiment conducted in the lab. organisms were probably collected in the field.
LTER_site_boundary	the entire LTER site, no more, no less
LTER_site_plus	contains at least part of the LTER site, plus other disconnected sites
LTER_site_subset	a subset of the LTER site
region	extends beyond LTER site into adjacent areas
single_point	a single place such as one transect
\.


--
-- TOC entry 3198 (class 0 OID 130405)
-- Dependencies: 212
-- Data for Name: cv_spatial_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatial_type (spatial_type, definition) FROM stdin;
multi_site	more than one location within the LTER site
non_spatial	there is no spatial component to this dataset
one_place_of_a_site_series	one place of a series of places
one_site_of_one	one site and not part of a series of sites
\.


--
-- TOC entry 3199 (class 0 OID 130411)
-- Dependencies: 213
-- Data for Name: cv_spatio_temporal; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_spatio_temporal (spatiotemporal, definition) FROM stdin;
csct	continuous spatial continuous temporal
csdt	continuous spatial discrete temporal
dsct	discrete spatial continuous temporal
dsdt	discrete spatial discrete temporal
\.


--
-- TOC entry 3200 (class 0 OID 130417)
-- Dependencies: 214
-- Data for Name: cv_status; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_status (status) FROM stdin;
anticipated
backlog
cataloged
catd_meta_antic_data
deprecated
draft
draft0
draft_template
redesign_anticipated
template
\.


--
-- TOC entry 3201 (class 0 OID 130420)
-- Dependencies: 215
-- Data for Name: cv_temporal_type; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

COPY pkg_mgmt.cv_temporal_type (temporal_type, definition) FROM stdin;
completed_timeseries	
non_temporal	
one_period_of_a_timeseries	
ongoing_timeseries	
short_term_study	
\.


--
-- TOC entry 3169 (class 0 OID 130199)
-- Dependencies: 173
-- Data for Name: pkg_core_area; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--


--
-- TOC entry 3170 (class 0 OID 130202)
-- Dependencies: 174
-- Data for Name: pkg_sort; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--

--
-- TOC entry 3171 (class 0 OID 130206)
-- Dependencies: 175
-- Data for Name: pkg_state; Type: TABLE DATA; Schema: pkg_mgmt; Owner: %db_owner%
--
