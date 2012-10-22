DROP TABLE IF EXISTS feature_details_aflp;
CREATE TABLE feature_details_aflp (
  feature_id int unsigned NOT NULL DEFAULT '0',
  molecular_weight int(11) DEFAULT NULL,
  adapter1_name varchar(50) DEFAULT NULL,
  adapter1_restriction varchar(50) DEFAULT NULL,
  adapter1_sequence varchar(50) DEFAULT NULL,
  adapter1_complement varchar(50) DEFAULT NULL,
  adapter2_name varchar(50) DEFAULT NULL,
  adapter2_restriction varchar(50) DEFAULT NULL,
  adapter2_sequence varchar(50) DEFAULT NULL,
  adapter2_complement varchar(50) DEFAULT NULL,
  primer1_name varchar(50) DEFAULT NULL,
  primer1_common_seq varchar(50) DEFAULT NULL,
  primer1_overhang varchar(50) DEFAULT NULL,
  primer2_name varchar(50) DEFAULT NULL,
  primer2_common_seq varchar(50) DEFAULT NULL,
  primer2_overhang varchar(50) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_centromere;
CREATE TABLE feature_details_centromere (
  feature_id int unsigned NOT NULL DEFAULT '0',
  chromosome varchar(50) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_clone;
CREATE TABLE feature_details_clone (
  feature_id int unsigned NOT NULL DEFAULT '0',
  clone_id varchar(50) DEFAULT NULL,
  forward_primer varchar(200) DEFAULT NULL,
  reverse_primer varchar(200) DEFAULT NULL,
  seq_primer varchar(200) DEFAULT NULL,
  clone_insert_length int(11) DEFAULT NULL,
  lab_host varchar(30) DEFAULT NULL,
  vector varchar(30) DEFAULT NULL,
  site1 varchar(30) DEFAULT NULL,
  site2 varchar(30) DEFAULT NULL,
  tissue_type varchar(30) DEFAULT NULL,
  clone varchar(32) DEFAULT NULL,
  date_created date DEFAULT NULL,
  date_updated date DEFAULT NULL,
  origin varchar(32) DEFAULT NULL,
  ref_authors text,
  ref_location varchar(32) DEFAULT NULL,
  ref_medline int(11) unsigned DEFAULT NULL,
  ref_pubmed int(11) unsigned DEFAULT NULL,
  ref_title varchar(255) DEFAULT NULL,
  ref_year int(4) unsigned DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_est;
CREATE TABLE feature_details_est (
  feature_id int unsigned NOT NULL DEFAULT '0',
  clone varchar(32) DEFAULT NULL,
  comment text,
  date_created date DEFAULT NULL,
  date_updated date DEFAULT NULL,
  lab_host varchar(32) DEFAULT NULL,
  map varchar(16) DEFAULT NULL,
  note text,
  origin varchar(32) DEFAULT NULL,
  ref_authors text,
  ref_location varchar(32) DEFAULT NULL,
  ref_medline int(11) unsigned DEFAULT NULL,
  ref_pubmed int(11) unsigned DEFAULT NULL,
  ref_title varchar(255) DEFAULT NULL,
  ref_year int(4) unsigned DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_est_cluster;
CREATE TABLE feature_details_est_cluster (
  feature_id int unsigned NOT NULL DEFAULT '0',
  date_updated date DEFAULT NULL,
  sequence_count int(6) unsigned DEFAULT NULL,
  est_count int(6) unsigned NOT NULL DEFAULT '0',
  htc_count int(6) unsigned NOT NULL DEFAULT '0',
  mrna_count int(6) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS feature_details_gene;
CREATE TABLE feature_details_gene (
  feature_id int unsigned NOT NULL DEFAULT '0',
  chromosome char(10) DEFAULT NULL,
  has_phenotype varchar(20) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS feature_details_genomic_dna;
CREATE TABLE feature_details_genomic_dna (
  feature_id int unsigned NOT NULL DEFAULT '0',
  EC_number varchar(64) DEFAULT NULL,
  allele varchar(32) DEFAULT NULL,
  bound_moiety varchar(255) DEFAULT NULL,
  cell_line varchar(128) DEFAULT NULL,
  cell_type varchar(128) DEFAULT NULL,
  chromosome varchar(128) DEFAULT NULL,
  citation varchar(32) DEFAULT NULL,
  clone varchar(255) DEFAULT NULL,
  clone_lib varchar(255) DEFAULT NULL,
  codon_start char(2) DEFAULT NULL,
  comment text,
  compare varchar(32) DEFAULT NULL,
  cons_splice varchar(64) DEFAULT NULL,
  country varchar(64) DEFAULT NULL,
  dev_stage varchar(255) DEFAULT NULL,
  ecotype varchar(32) DEFAULT NULL,
  evidence varchar(32) DEFAULT NULL,
  exception varchar(32) DEFAULT NULL,
  function varchar(255) DEFAULT NULL,
  gene varchar(255) DEFAULT NULL,
  germline varchar(32) DEFAULT NULL,
  haplotype varchar(64) DEFAULT NULL,
  insertion_seq varchar(32) DEFAULT NULL,
  isolate varchar(128) DEFAULT NULL,
  isolation_source varchar(255) DEFAULT NULL,
  keyword varchar(255) DEFAULT NULL,
  lab_host varchar(64) DEFAULT NULL,
  label varchar(32) DEFAULT NULL,
  locus_tag varchar(64) DEFAULT NULL,
  macronuclear varchar(32) DEFAULT NULL,
  map varchar(128) DEFAULT NULL,
  mod_base varchar(8) DEFAULT NULL,
  mol_type varchar(32) DEFAULT NULL,
  note text,
  number char(2) DEFAULT NULL,
  origin varchar(128) DEFAULT NULL,
  patent varchar(100) DEFAULT NULL,
  phenotype varchar(128) DEFAULT NULL,
  plasmid varchar(32) DEFAULT NULL,
  pop_variant varchar(16) DEFAULT NULL,
  product text,
  protein_id varchar(32) DEFAULT NULL,
  pseudo varchar(32) DEFAULT NULL,
  rearranged varchar(32) DEFAULT NULL,
  ref_authors text,
  ref_location text,
  ref_pubmed varchar(16) DEFAULT NULL,
  ref_title text,
  ref_year int(4) unsigned DEFAULT NULL,
  rpt_family varchar(64) DEFAULT NULL,
  rpt_type varchar(32) DEFAULT NULL,
  rpt_unit varchar(128) DEFAULT NULL,
  sex varchar(64) DEFAULT NULL,
  specimen_voucher varchar(128) DEFAULT NULL,
  standard_name varchar(128) DEFAULT NULL,
  sub_clone varchar(64) DEFAULT NULL,
  sub_species varchar(64) DEFAULT NULL,
  sub_strain varchar(16) DEFAULT NULL,
  tissue_lib varchar(255) DEFAULT NULL,
  tissue_type varchar(255) DEFAULT NULL,
  transl_except varchar(64) DEFAULT NULL,
  transl_table varchar(4) DEFAULT NULL,
  translation text,
  transposon varchar(64) DEFAULT NULL,
  variety varchar(64) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_gss;
CREATE TABLE feature_details_gss (
  feature_id int unsigned NOT NULL DEFAULT '0',
  read_direction varchar(20) DEFAULT NULL,
  insert_size varchar(20) DEFAULT NULL,
  template varchar(20) DEFAULT NULL,
  cell_line varchar(32) DEFAULT NULL,
  cell_type varchar(32) DEFAULT NULL,
  clone varchar(32) DEFAULT NULL,
  clone_lib varchar(255) DEFAULT NULL,
  comment text,
  date_created date DEFAULT NULL,
  date_updated date DEFAULT NULL,
  dev_stage varchar(255) DEFAULT NULL,
  lab_host varchar(32) DEFAULT NULL,
  map varchar(16) DEFAULT NULL,
  note text,
  origin varchar(32) DEFAULT NULL,
  ref_authors text,
  ref_location varchar(32) DEFAULT NULL,
  ref_medline int(11) unsigned DEFAULT NULL,
  ref_pubmed int(11) unsigned DEFAULT NULL,
  ref_title varchar(255) DEFAULT NULL,
  ref_year int(4) unsigned DEFAULT NULL,
  sex varchar(32) DEFAULT NULL,
  tissue_type varchar(255) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  KEY (template),
  KEY (clone),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS feature_details_mrna;
CREATE TABLE feature_details_mrna (
  feature_id int unsigned NOT NULL DEFAULT '0',
  date_created date DEFAULT NULL,
  date_updated date DEFAULT NULL,
  EC_number varchar(64) DEFAULT NULL,
  allele varchar(32) DEFAULT NULL,
  bound_moiety varchar(255) DEFAULT NULL,
  cell_line varchar(128) DEFAULT NULL,
  cell_type varchar(128) DEFAULT NULL,
  chromosome varchar(128) DEFAULT NULL,
  citation varchar(32) DEFAULT NULL,
  clone varchar(255) DEFAULT NULL,
  clone_lib varchar(255) DEFAULT NULL,
  codon_start char(2) DEFAULT NULL,
  comment text,
  compare varchar(32) DEFAULT NULL,
  cons_splice varchar(64) DEFAULT NULL,
  country varchar(64) DEFAULT NULL,
  dev_stage varchar(255) DEFAULT NULL,
  ecotype varchar(32) DEFAULT NULL,
  evidence varchar(32) DEFAULT NULL,
  exception varchar(32) DEFAULT NULL,
  function varchar(255) DEFAULT NULL,
  gene varchar(255) DEFAULT NULL,
  germline varchar(32) DEFAULT NULL,
  haplotype varchar(64) DEFAULT NULL,
  insertion_seq varchar(32) DEFAULT NULL,
  isolate varchar(128) DEFAULT NULL,
  isolation_source varchar(255) DEFAULT NULL,
  keyword varchar(255) DEFAULT NULL,
  lab_host varchar(64) DEFAULT NULL,
  label varchar(32) DEFAULT NULL,
  locus_tag varchar(64) DEFAULT NULL,
  macronuclear varchar(32) DEFAULT NULL,
  map varchar(128) DEFAULT NULL,
  mod_base varchar(8) DEFAULT NULL,
  mol_type varchar(32) DEFAULT NULL,
  note text,
  number char(2) DEFAULT NULL,
  origin varchar(128) DEFAULT NULL,
  phenotype varchar(128) DEFAULT NULL,
  plasmid varchar(32) DEFAULT NULL,
  pop_variant varchar(16) DEFAULT NULL,
  product text,
  protein_id varchar(32) DEFAULT NULL,
  pseudo varchar(32) DEFAULT NULL,
  rearranged varchar(32) DEFAULT NULL,
  ref_authors text,
  ref_location text,
  ref_pubmed varchar(16) DEFAULT NULL,
  ref_title text,
  ref_year int(4) unsigned DEFAULT NULL,
  rpt_family varchar(64) DEFAULT NULL,
  rpt_type varchar(32) DEFAULT NULL,
  rpt_unit varchar(128) DEFAULT NULL,
  sex varchar(64) DEFAULT NULL,
  specimen_voucher varchar(128) DEFAULT NULL,
  standard_name varchar(128) DEFAULT NULL,
  sub_clone varchar(64) DEFAULT NULL,
  sub_species varchar(64) DEFAULT NULL,
  sub_strain varchar(16) DEFAULT NULL,
  tissue_lib varchar(255) DEFAULT NULL,
  tissue_type varchar(255) DEFAULT NULL,
  transl_except varchar(64) DEFAULT NULL,
  transl_table varchar(4) DEFAULT NULL,
  translation text,
  transposon varchar(64) DEFAULT NULL,
  variety varchar(64) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS feature_details_primer;
CREATE TABLE feature_details_primer (
  feature_id int unsigned NOT NULL DEFAULT '0',
  feature_accession varchar(50) DEFAULT NULL,
  direction varchar(50) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_qtl;
CREATE TABLE feature_details_qtl (
  feature_id int unsigned NOT NULL DEFAULT '0',
  chromosome char(10) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_rapd;
CREATE TABLE feature_details_rapd (
  feature_id int unsigned NOT NULL DEFAULT '0',
  primer1 varchar(50) DEFAULT NULL,
  primer2 varchar(50) DEFAULT NULL,
  band_size double DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_rflp;
CREATE TABLE feature_details_rflp (
  feature_id int unsigned NOT NULL DEFAULT '0',
  dna_treatment varchar(50) DEFAULT NULL,
  source_type varchar(50) DEFAULT NULL,
  source_tissue varchar(50) DEFAULT NULL,
  source_treatment varchar(50) DEFAULT NULL,
  vector varchar(50) DEFAULT NULL,
  vector_antibiotic_resistance varchar(50) DEFAULT NULL,
  fragment_size double DEFAULT NULL,
  vector_excision_enzyme varchar(50) DEFAULT NULL,
  vector_primers varchar(50) DEFAULT NULL,
  overgo1 varchar(30) DEFAULT '',
  overgo2 varchar(30) DEFAULT '',
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_snp;
CREATE TABLE feature_details_snp (
  feature_id int unsigned NOT NULL DEFAULT '0',
  primer1 varchar(50) DEFAULT NULL,
  primer2 varchar(50) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS feature_details_sscp;
CREATE TABLE feature_details_sscp (
  feature_id int unsigned NOT NULL DEFAULT '0',
  primer1 varchar(50) DEFAULT NULL,
  primer2 varchar(50) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_ssr;
CREATE TABLE feature_details_ssr (
  feature_id int unsigned NOT NULL DEFAULT '0',
  repeat_motif varchar(50) DEFAULT NULL,
  anneal_temperature int(11) DEFAULT NULL,
  product_size int(11) DEFAULT NULL,
  sequence_source varchar(50) DEFAULT NULL,
  linkage_group varchar(10) DEFAULT NULL,
  remarks text,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS feature_details_sts;
CREATE TABLE feature_details_sts (
  feature_id int unsigned NOT NULL DEFAULT '0',
  primer1 varchar(50) DEFAULT NULL,
  primer2 varchar(50) DEFAULT NULL,
  reference varchar(50) DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS feature_details_fpc;
CREATE TABLE feature_details_fpc (
  feature_id int unsigned NOT NULL DEFAULT '0',
  length_band int unsigned DEFAULT NULL,
  length_basepair int unsigned DEFAULT NULL,
  clone_count int unsigned DEFAULT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES feature (feature_id)
) ENGINE=InnoDB;
