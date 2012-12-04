DROP DATABASE IF EXISTS maps36;
CREATE DATABASE maps36;
USE maps36;

DROP TABLE IF EXISTS xref;
DROP TABLE IF EXISTS xref_type;
DROP TABLE IF EXISTS mapping;
DROP TABLE IF EXISTS feature_to_ontology_term;
DROP TABLE IF EXISTS ontology_term;
DROP TABLE IF EXISTS ontology_term_type;
DROP TABLE IF EXISTS feature_synonym;
DROP TABLE IF EXISTS synonym_type;
DROP TABLE IF EXISTS feature_image;
DROP TABLE IF EXISTS feature;
DROP TABLE IF EXISTS feature_type;
DROP TABLE IF EXISTS map;
DROP TABLE IF EXISTS map_set;
DROP TABLE IF EXISTS map_type;
DROP TABLE IF EXISTS species;
DROP TABLE IF EXISTS feature_relation_type;
DROP TABLE IF EXISTS feature_relation;
DROP TABLE IF EXISTS feature_to_ontology_term;
DROP TABLE IF EXISTS ontology_term;
DROP TABLE IF EXISTS ontology_term_type;
DROP TABLE IF EXISTS germplasm;

CREATE TABLE species (
  species_id int unsigned NOT NULL AUTO_INCREMENT,
  species varchar(255) NOT NULL,
  common_name varchar(255) DEFAULT NULL,
  gramene_taxonomy_id varchar(20) DEFAULT NULL,
  ncbi_taxonomy_id varchar(20) DEFAULT NULL,
  PRIMARY KEY (species_id),
  UNIQUE (species),
  UNIQUE (gramene_taxonomy_id),
  UNIQUE (ncbi_taxonomy_id),
  KEY (species),
  KEY (gramene_taxonomy_id),
  KEY (ncbi_taxonomy_id)
) ENGINE=InnoDB;

CREATE TABLE germplasm (
  germplasm_id int unsigned NOT NULL AUTO_INCREMENT,
  germplasm_acc varchar(30) DEFAULT NULL,
  germplasm_name varchar(255) NOT NULL,
  species_id int unsigned NOT NULL DEFAULT '1',
  description text,
  PRIMARY KEY (germplasm_id),
  UNIQUE (species_id, germplasm_name),
  UNIQUE (germplasm_acc),
  KEY (species_id),
  KEY (germplasm_name),
  KEY (germplasm_acc),
  FOREIGN KEY (species_id) REFERENCES species (species_id)
) ENGINE=InnoDB;

CREATE TABLE map_type (
  map_type_id int unsigned NOT NULL AUTO_INCREMENT,
  map_type varchar(50) NOT NULL DEFAULT '',
  description text,
  PRIMARY KEY (map_type_id),
  UNIQUE (map_type)
) ENGINE=InnoDB;

CREATE TABLE map_set (
  map_set_id int unsigned NOT NULL AUTO_INCREMENT,
  map_type_id int unsigned NOT NULL DEFAULT '1',
  species_id int unsigned NOT NULL DEFAULT '1',
  map_set_acc varchar(30) NOT NULL DEFAULT '',
  map_set_name varchar(50) NOT NULL DEFAULT '',
  description text,
  total_length varchar(50) DEFAULT NULL,
  distance_unit varchar(50) DEFAULT NULL,
  published_on date DEFAULT NULL,
  PRIMARY KEY (map_set_id),
  UNIQUE (map_set_acc),
  KEY (map_type_id),
  KEY (species_id),
  FOREIGN KEY (map_type_id) REFERENCES map_type (map_type_id),
  FOREIGN KEY (species_id) REFERENCES species (species_id)
) ENGINE=InnoDB;

CREATE TABLE map (
  map_id int unsigned NOT NULL AUTO_INCREMENT,
  map_set_id int unsigned NOT NULL DEFAULT '0',
  map_acc varchar(30) NOT NULL DEFAULT '',
  map_name varchar(50) NOT NULL DEFAULT '',
  display_order smallint(6) NOT NULL DEFAULT '0',
  start double(11,2) NOT NULL DEFAULT '0',
  end double(11,2) DEFAULT NULL,
  PRIMARY KEY (map_id),
  UNIQUE (map_acc),
  KEY (map_set_id),
  KEY (map_name),
  FOREIGN KEY (map_set_id) REFERENCES map_set (map_set_id)
) ENGINE=InnoDB;

CREATE TABLE feature_type (
  feature_type_id int unsigned NOT NULL AUTO_INCREMENT,
  feature_type varchar(50) NOT NULL DEFAULT '',
  description text,
  PRIMARY KEY (feature_type_id),
  UNIQUE (feature_type)
) ENGINE=InnoDB;

CREATE TABLE feature (
  feature_id int unsigned NOT NULL AUTO_INCREMENT,
  feature_type_id int unsigned NOT NULL DEFAULT '1',
  species_id int unsigned NOT NULL DEFAULT '1',
  display_synonym_id int unsigned DEFAULT NULL,
  feature_acc varchar(50) NOT NULL DEFAULT '',
  description text,
  PRIMARY KEY (feature_id),
  UNIQUE (feature_acc),
  KEY (feature_type_id),
  KEY (display_synonym_id),
  KEY (species_id),
  FOREIGN KEY (feature_type_id) REFERENCES feature_type (feature_type_id),
  FOREIGN KEY (species_id) REFERENCES species (species_id)
) ENGINE=InnoDB;

CREATE TABLE feature_image (
  feature_image_id int unsigned NOT NULL AUTO_INCREMENT,
  feature_id int unsigned NOT NULL DEFAULT '0',
  file_name varchar(50) NOT NULL DEFAULT '',
  caption text,
  width int unsigned DEFAULT NULL,
  height int unsigned DEFAULT NULL,
  PRIMARY KEY (feature_image_id),
  UNIQUE (feature_id,file_name),
  KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

CREATE TABLE synonym_type (
  synonym_type_id int unsigned NOT NULL AUTO_INCREMENT,
  synonym_type varchar(64) NOT NULL,
  url_template varchar(255) DEFAULT NULL,
  preprocess_name_for_url varchar(255) DEFAULT NULL,
  description text,
  validation text,
  PRIMARY KEY (synonym_type_id),
  UNIQUE (synonym_type)
) ENGINE=InnoDB;

CREATE TABLE feature_synonym (
  feature_synonym_id int unsigned NOT NULL AUTO_INCREMENT,
  feature_id int unsigned NOT NULL DEFAULT '0',
  synonym_type_id int unsigned NOT NULL DEFAULT '1',
  feature_name varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (feature_synonym_id),
  UNIQUE (feature_id,synonym_type_id,feature_name),
  KEY (feature_id),
  KEY (synonym_type_id),
  KEY (feature_name),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id),
  FOREIGN KEY (synonym_type_id) REFERENCES synonym_type (synonym_type_id)
) ENGINE=InnoDB;

ALTER TABLE feature ADD
  FOREIGN KEY (display_synonym_id) REFERENCES feature_synonym (feature_synonym_id);

CREATE TABLE ontology_term_type (
  ontology_term_type_id int unsigned NOT NULL AUTO_INCREMENT,
  term_type varchar(128) DEFAULT NULL,
  PRIMARY KEY (ontology_term_type_id),
  UNIQUE (term_type)
) ENGINE=InnoDB;

CREATE TABLE ontology_term (
  ontology_term_id int unsigned NOT NULL AUTO_INCREMENT,
  ontology_term_type_id int unsigned NOT NULL DEFAULT '0',
  term_accession varchar(32) NOT NULL,
  PRIMARY KEY (ontology_term_id),
  UNIQUE (ontology_term_type_id,term_accession),
  KEY (term_accession),
  FOREIGN KEY (ontology_term_type_id) REFERENCES ontology_term_type (ontology_term_type_id)
) ENGINE=InnoDB;

CREATE TABLE feature_to_ontology_term (
  feature_to_ontology_term_id int unsigned NOT NULL AUTO_INCREMENT,
  feature_id int unsigned NOT NULL DEFAULT '0',
  ontology_term_id int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (feature_to_ontology_term_id),
  UNIQUE (feature_to_ontology_term_id,feature_id),
  KEY (feature_id),
  KEY (ontology_term_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id),
  FOREIGN KEY (ontology_term_id) REFERENCES ontology_term (ontology_term_id)
) ENGINE=InnoDB;

CREATE TABLE mapping (
  mapping_id int unsigned NOT NULL AUTO_INCREMENT,
  map_id int unsigned NOT NULL DEFAULT '0',
  feature_id int unsigned NOT NULL DEFAULT '0',
  display_synonym_id int unsigned DEFAULT NULL,
  mapping_acc varchar(30) DEFAULT NULL,
  start double NOT NULL DEFAULT '0',
  end double DEFAULT NULL,
  PRIMARY KEY (mapping_id),
  UNIQUE (mapping_acc),
  KEY (map_id),
  KEY (feature_id),
  KEY (display_synonym_id),
  KEY (mapping_acc),
  FOREIGN KEY (map_id) REFERENCES map (map_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id),
  FOREIGN KEY (display_synonym_id) REFERENCES feature_synonym (feature_synonym_id)
) ENGINE=InnoDB;

CREATE TABLE xref_type (
  xref_type_id int unsigned NOT NULL AUTO_INCREMENT,
  xref_type varchar(100) NOT NULL DEFAULT '',
  url_template text NOT NULL,
  PRIMARY KEY (xref_type_id),
  UNIQUE (xref_type)
) ENGINE=InnoDB;

CREATE TABLE xref (
  xref_id int unsigned NOT NULL AUTO_INCREMENT,
  table_name varchar(50) NOT NULL DEFAULT '',
  record_id int unsigned NOT NULL DEFAULT '0',
  xref_type_id int unsigned NOT NULL DEFAULT '0',
  xref_value varchar(255) NOT NULL DEFAULT '',
  comments text,
  PRIMARY KEY (xref_id),
  KEY (xref_type_id),
  KEY (record_id),
  KEY (table_name,record_id,xref_type_id),
  FOREIGN KEY (xref_type_id) REFERENCES xref_type (xref_type_id)
) ENGINE=InnoDB;

CREATE TABLE feature_relation_type (
  feature_relation_type_id int unsigned NOT NULL AUTO_INCREMENT,
  type varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (feature_relation_type_id),
  UNIQUE (type)
);

CREATE TABLE feature_relation (
  feature_relation_id int unsigned NOT NULL AUTO_INCREMENT,
  feature_relation_type_id int unsigned DEFAULT '0',
  from_feature_id int unsigned DEFAULT '0',
  to_feature_id int unsigned DEFAULT '0',
  PRIMARY KEY (feature_relation_id),
  KEY (feature_relation_id),
  KEY (from_feature_id),
  KEY (to_feature_id),
  FOREIGN KEY (feature_relation_id) 
    REFERENCES feature_relation (feature_relation_id),
  FOREIGN KEY (from_feature_id) REFERENCES feature (feature_id),
  FOREIGN KEY (to_feature_id) REFERENCES feature (feature_id)
);

CREATE TABLE germplasm_to_map_set (
  germplasm_to_map_set_id int unsigned NOT NULL AUTO_INCREMENT,
  germplasm_id int unsigned NOT NULL DEFAULT '0',
  map_set_id int unsigned NOT NULL DEFAULT '0',
  relationship enum('Unknown','Donor Parent','Female Parent','Male Parent','Parental Germplasm','Recurrent Parent') DEFAULT NULL,
  PRIMARY KEY (germplasm_to_map_set_id),
  UNIQUE (germplasm_id,map_set_id,relationship),
  KEY (germplasm_id),
  KEY (map_set_id),
  FOREIGN KEY (germplasm_id) REFERENCES germplasm (germplasm_id),
  FOREIGN KEY (map_set_id) REFERENCES map_set (map_set_id)
) ENGINE=InnoDB;
