--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = semantic_annotation, pg_catalog;

--
-- Data for Name: DataSetAnnotation; Type: TABLE DATA; Schema: semantic_annotation; Owner: gastil
--

COPY "DataSetAnnotation" ("DataSetID", "TermID", "ObjectPropertyID") FROM stdin;
99024	ENVO_01000058	IAO_0000136
99054	ENVO_01000058	IAO_0000136
\.


--
-- Data for Name: DataSetAttributeAnnotation; Type: TABLE DATA; Schema: semantic_annotation; Owner: gastil
--

COPY "DataSetAttributeAnnotation" ("DataSetID", "EntitySortOrder", "ColumnPosition", "TermID", "ObjectPropertyID") FROM stdin;
99021	2	5	ECSO_00001180	containsMeasurementsOfType
99024	1	15	ECSO_00000639	containsMeasurementsOfType
99013	1	2	ECSO_00002040	containsMeasurementsOfType
99024	1	2	ECSO_00002050	containsMeasurementsOfType
99054	101	1	ECSO_00002130	containsMeasurementsOfType
99054	101	2	ECSO_00002132	containsMeasurementsOfType
\.


--
-- Data for Name: EMLObjectProperties; Type: TABLE DATA; Schema: semantic_annotation; Owner: gastil
--

COPY "EMLObjectProperties" ("ObjectPropertyID", "ObjectPropertyLabel", "ObjectPropertyURI") FROM stdin;
containsMeasurementsOfType	contains measurements of type	http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType
IAO_0000136	is about	http://purl.obolibrary.org/obo/IAO_0000136
\.


--
-- Data for Name: EMLSemanticAnnotationTerms; Type: TABLE DATA; Schema: semantic_annotation; Owner: gastil
--

COPY "EMLSemanticAnnotationTerms" ("TermID", "TermLabel", "TermURI") FROM stdin;
ENVO_01000058	Kelp Forest	http://purl.obolibrary.org/obo/ENVO_01000058
ECSO_00001180	Carbon Biomass Density	http://purl.dataone.org/odo/ECSO_00001180
ECSO_00000639	carbon to nitrogen molar ratio	http://purl.dataone.org/odo/ECSO_00000639
ECSO_00002043	date and time of measurement\n\n	http://purl.dataone.org/odo/ECSO_00002043
ECSO_00002040	time of measurement	http://purl.dataone.org/odo/ECSO_00002040
ECSO_00002051	date	http://purl.dataone.org/odo/ECSO_00002051
ECSO_00002050	year of measurement\n\n	http://purl.dataone.org/odo/ECSO_00002050
ECSO_00002130	latitude coordinate	http://purl.dataone.org/odo/ECSO_00002130
ECSO_00002132	longitude coordinate	http://purl.dataone.org/odo/ECSO_00002132
\.


--
-- PostgreSQL database dump complete
--

