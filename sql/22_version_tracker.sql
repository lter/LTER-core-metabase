-- create metabase version tracker

CREATE TABLE pkg_mgmt.version_tracker_metabase (
	major_version int4 NOT NULL,
	minor_version int4 NOT NULL,
	patch int4 NULL,
	date_installed timestamp NULL,
	"comment" text NULL
);

ALTER TABLE pkg_mgmt.version_tracker_metabase
  ADD CONSTRAINT "PK_version_tracker_metabase" PRIMARY KEY (major_version, minor_version, patch);

INSERT INTO pkg_mgmt.version_tracker_metabase
(major_version, minor_version, patch, date_installed, "comment")
VALUES(0, 9, 22, now(), 'apply 22_version_tracker');
