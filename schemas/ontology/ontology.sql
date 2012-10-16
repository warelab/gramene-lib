SET foreign_key_checks=0;

DROP TABLE IF EXISTS data_base;
CREATE TABLE data_base (
  data_base_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(55) NOT NULL DEFAULT '',
  fullname varchar(255) DEFAULT NULL,
  datatype varchar(255) DEFAULT NULL,
  generic_url varchar(255) DEFAULT NULL,
  url_syntax varchar(255) DEFAULT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS dbxref;
CREATE TABLE dbxref (
  dbxref_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  xref_key varchar(255) NOT NULL DEFAULT '',
  xref_keytype varchar(32) DEFAULT NULL,
  xref_dbname varchar(64) NOT NULL DEFAULT '',
  xref_desc varchar(255) DEFAULT NULL,
  UNIQUE (xref_key,xref_keytype,xref_dbname)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS evidence;
CREATE TABLE evidence (
  evidence_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  evidence_code varchar(8) NOT NULL DEFAULT '',
  association_id INT NOT NULL DEFAULT '0',
  object_class varchar(32) NOT NULL DEFAULT '',
  dbxref_id INT NOT NULL DEFAULT '0',
  seq_acc varchar(255) DEFAULT NULL,
  KEY (dbxref_id),
  FOREIGN KEY (dbxref_id) REFERENCES dbxref (dbxref_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS term_type;
CREATE TABLE term_type (
  term_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_type varchar(128) NOT NULL DEFAULT ''
) ENGINE=InnoDB;

DROP TABLE IF EXISTS relationship_type;
CREATE TABLE relationship_type (
  relationship_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  type_name varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB;

DROP TABLE IF EXISTS species;
CREATE TABLE species (
  species_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ncbi_taxa_id INT DEFAULT NULL,
  common_name varchar(255) DEFAULT NULL,
  lineage_string text,
  genus varchar(32) DEFAULT NULL,
  species varchar(32) DEFAULT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS term;
CREATE TABLE term (
  term_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255) NOT NULL DEFAULT '',
  term_type_id INT NOT NULL DEFAULT '0',
  term_accession varchar(32) NOT NULL DEFAULT '',
  is_obsolete tinyint(1) NOT NULL DEFAULT '0',
  is_root tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE (term_type_id,term_accession),
  KEY (term_accession),
  FOREIGN KEY (term_type_id) REFERENCES term_type (term_type_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS term_dbxref;
CREATE TABLE term_dbxref (
  term_dbxref_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_id INT NOT NULL DEFAULT '0',
  dbxref_id INT NOT NULL DEFAULT '0',
  is_for_definition INT NOT NULL DEFAULT '0',
  UNIQUE (term_id,dbxref_id,is_for_definition),
  KEY (term_id),
  KEY (dbxref_id),
  FOREIGN KEY (term_id) REFERENCES term (term_id),
  FOREIGN KEY (dbxref_id) REFERENCES dbxref (dbxref_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS term_definition;
CREATE TABLE term_definition (
  term_definition_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_id INT NOT NULL DEFAULT '0',
  dbxref_id INT DEFAULT NULL,
  definition text NOT NULL,
  term_comment text,
  reference varchar(255) DEFAULT NULL,
  UNIQUE (term_id),
  KEY (term_id),
  FOREIGN KEY (term_id) REFERENCES term (term_id),
  FOREIGN KEY (dbxref_id) REFERENCES dbxref (dbxref_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS term_synonym;
CREATE TABLE term_synonym (
  term_synonym_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_id INT NOT NULL DEFAULT '0',
  term_synonym varchar(500) NOT NULL DEFAULT '',
  UNIQUE (term_id,term_synonym),
  KEY (term_id),
  FOREIGN KEY (term_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS term_to_term;
CREATE TABLE term_to_term (
  term_to_term_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  relationship_type_id INT NOT NULL DEFAULT '0',
  term1_id INT NOT NULL DEFAULT '0',
  term2_id INT NOT NULL DEFAULT '0',
  UNIQUE (term1_id,term2_id, relationship_type_id),
  KEY (relationship_type_id),
  KEY (term1_id),
  KEY (term2_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_type (relationship_type_id),
  FOREIGN KEY (term1_id) REFERENCES term (term_id),
  FOREIGN KEY (term2_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS association;
CREATE TABLE association (
  association_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_id INT NOT NULL DEFAULT '0',
  gene_product_id INT NOT NULL DEFAULT '0',
  object_class varchar(32) NOT NULL DEFAULT '',
  is_not tinyint(1) DEFAULT NULL,
  role_group INT DEFAULT NULL,
  KEY (term_id),
  KEY (term_id,gene_product_id,object_class),
  FOREIGN KEY (term_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS graph_path;
CREATE TABLE graph_path (
  graph_path_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term1_id INT NOT NULL DEFAULT '0',
  term2_id INT NOT NULL DEFAULT '0',
  distance INT NOT NULL DEFAULT '0',
  KEY (term1_id),
  KEY (term2_id),
  FOREIGN KEY (term1_id) REFERENCES term (term_id),
  FOREIGN KEY (term2_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS graph_path_to_term;
CREATE TABLE graph_path_to_term (
  graph_path_to_term_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  graph_path_id INT NOT NULL DEFAULT '0',
  term_id INT NOT NULL DEFAULT '0',
  rank INT NOT NULL DEFAULT '0',
  KEY (graph_path_id),
  KEY (term_id),
  FOREIGN KEY (graph_path_id) REFERENCES graph_path (graph_path_id),
  FOREIGN KEY (term_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS object_association_count;
CREATE TABLE object_association_count (
  object_association_count_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_id INT NOT NULL DEFAULT '0',
  object_type varchar(128) NOT NULL DEFAULT '',
  object_species varchar(128) NOT NULL DEFAULT '',
  object_count INT NOT NULL DEFAULT '0',
  association_count INT NOT NULL DEFAULT '0',
  UNIQUE (term_id,object_type,object_species),
  FOREIGN KEY (term_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS quick_term_to_object;
CREATE TABLE quick_term_to_object (
  quick_term_to_object_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  term_id INT NOT NULL DEFAULT '0',
  term_accession varchar(15) NOT NULL DEFAULT '',
  term_name varchar(255) NOT NULL DEFAULT '',
  term_type varchar(64) NOT NULL DEFAULT '',
  object_database varchar(64) NOT NULL DEFAULT '',
  object_type varchar(64) NOT NULL DEFAULT '',
  object_accession_id varchar(64) NOT NULL DEFAULT '',
  object_symbol varchar(255) NOT NULL DEFAULT '',
  object_name varchar(255) DEFAULT NULL,
  object_synonyms text,
  object_species varchar(128) NOT NULL DEFAULT '',
  evidences varchar(255) NOT NULL DEFAULT '',
  UNIQUE (term_id,object_database,object_type,object_accession_id),
  KEY (term_id),
  KEY (term_name),
  KEY (object_symbol),
  KEY (object_species),
  FOREIGN KEY (term_id) REFERENCES term (term_id)
) ENGINE=InnoDB;

