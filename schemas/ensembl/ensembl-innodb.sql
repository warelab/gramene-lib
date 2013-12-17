-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Tue Dec 17 17:32:15 2013
-- 
SET foreign_key_checks=0;

--
-- Table: assembly
--
CREATE TABLE assembly (
  asm_seq_region_id integer(10) unsigned NOT NULL,
  cmp_seq_region_id integer(10) unsigned NOT NULL,
  asm_start integer(10) NOT NULL,
  asm_end integer(10) NOT NULL,
  cmp_start integer(10) NOT NULL,
  cmp_end integer(10) NOT NULL,
  ori TINYINT(4) NOT NULL,
  INDEX cmp_seq_region_idx (cmp_seq_region_id),
  INDEX asm_seq_region_idx (asm_seq_region_id, asm_start),
  UNIQUE all_idx (asm_seq_region_id, cmp_seq_region_id, asm_start, asm_end, cmp_start, cmp_end, ori),
  CONSTRAINT assembly_fk FOREIGN KEY (asm_seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT assembly_fk_1 FOREIGN KEY (cmp_seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: assembly_exception
--
CREATE TABLE assembly_exception (
  assembly_exception_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  exc_type ENUM('HAP', 'PAR', 'PATCH_FIX', 'PATCH_NOVEL') NOT NULL,
  exc_seq_region_id integer(10) unsigned NOT NULL,
  exc_seq_region_start integer(10) unsigned NOT NULL,
  exc_seq_region_end integer(10) unsigned NOT NULL,
  ori integer(11) NOT NULL,
  INDEX sr_idx (seq_region_id, seq_region_start),
  INDEX ex_idx (exc_seq_region_id, exc_seq_region_start),
  PRIMARY KEY (assembly_exception_id),
  CONSTRAINT assembly_exception_fk FOREIGN KEY (exc_seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT assembly_exception_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: coord_system
--
CREATE TABLE coord_system (
  coord_system_id integer(10) unsigned NOT NULL auto_increment,
  species_id integer(10) unsigned NOT NULL DEFAULT 1,
  name VARCHAR(40) NOT NULL,
  version VARCHAR(255) NULL DEFAULT NULL,
  rank integer(11) NOT NULL,
  attrib SET('default_version', 'sequence_level') NULL,
  INDEX species_idx (species_id),
  PRIMARY KEY (coord_system_id),
  UNIQUE rank_idx (rank, species_id),
  UNIQUE name_idx (name, version, species_id)
) ENGINE=InnoDB;

--
-- Table: data_file
--
CREATE TABLE data_file (
  data_file_id integer(10) unsigned NOT NULL auto_increment,
  coord_system_id integer(10) unsigned NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  name VARCHAR(100) NOT NULL,
  version_lock TINYINT(1) NOT NULL DEFAULT 0,
  absolute TINYINT(1) NOT NULL DEFAULT 0,
  url text NULL,
  file_type ENUM('BAM', 'BIGBED', 'BIGWIG', 'VCF') NULL,
  INDEX df_name_idx (name),
  INDEX df_analysis_idx (analysis_id),
  INDEX (coord_system_id),
  PRIMARY KEY (data_file_id),
  UNIQUE df_unq_idx (coord_system_id, analysis_id, name, file_type),
  CONSTRAINT data_file_fk FOREIGN KEY (coord_system_id) REFERENCES coord_system (coord_system_id),
  CONSTRAINT data_file_fk_1 FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB;

--
-- Table: dna
--
CREATE TABLE dna (
  seq_region_id integer(10) unsigned NOT NULL,
  sequence LONGTEXT NOT NULL,
  INDEX (seq_region_id),
  PRIMARY KEY (seq_region_id),
  CONSTRAINT dna_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT dna_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB MAX_ROWS=750000 AVG_ROW_LENGTH=19000;

--
-- Table: karyotype
--
CREATE TABLE karyotype (
  karyotype_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  band VARCHAR(40) NOT NULL,
  stain VARCHAR(40) NOT NULL,
  INDEX region_band_idx (seq_region_id, band),
  PRIMARY KEY (karyotype_id),
  CONSTRAINT karyotype_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: meta
--
CREATE TABLE meta (
  meta_id integer(11) NOT NULL auto_increment,
  species_id integer(10) unsigned NULL DEFAULT 1,
  meta_key VARCHAR(40) NOT NULL,
  meta_value VARCHAR(255) binary NULL,
  INDEX species_value_idx (species_id, meta_value),
  PRIMARY KEY (meta_id),
  UNIQUE species_key_value_idx (species_id, meta_key, meta_value)
) ENGINE=InnoDB;

--
-- Table: meta_coord
--
CREATE TABLE meta_coord (
  table_name VARCHAR(40) NOT NULL,
  coord_system_id integer(10) unsigned NOT NULL,
  max_length integer(11) NULL,
  INDEX (coord_system_id),
  UNIQUE cs_table_name_idx (coord_system_id, table_name),
  CONSTRAINT meta_coord_fk FOREIGN KEY (coord_system_id) REFERENCES coord_system (coord_system_id)
) ENGINE=InnoDB;

--
-- Table: seq_region
--
CREATE TABLE seq_region (
  seq_region_id integer(10) unsigned NOT NULL auto_increment,
  name VARCHAR(40) NOT NULL,
  coord_system_id integer(10) unsigned NOT NULL,
  length integer(10) unsigned NOT NULL,
  INDEX cs_idx (coord_system_id),
  PRIMARY KEY (seq_region_id),
  UNIQUE name_cs_idx (name, coord_system_id),
  CONSTRAINT seq_region_fk FOREIGN KEY (coord_system_id) REFERENCES coord_system (coord_system_id)
) ENGINE=InnoDB;

--
-- Table: seq_region_synonym
--
CREATE TABLE seq_region_synonym (
  seq_region_synonym_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  synonym VARCHAR(40) NOT NULL,
  external_db_id integer(10) unsigned NULL,
  INDEX seq_region_idx (seq_region_id),
  PRIMARY KEY (seq_region_synonym_id),
  UNIQUE syn_idx (synonym)
) ENGINE=InnoDB;

--
-- Table: seq_region_attrib
--
CREATE TABLE seq_region_attrib (
  seq_region_id integer(10) unsigned NOT NULL DEFAULT 0,
  attrib_type_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  value varchar(255) NOT NULL,
  INDEX type_val_idx (attrib_type_id, value),
  INDEX val_only_idx (value),
  INDEX seq_region_idx (seq_region_id),
  CONSTRAINT seq_region_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT seq_region_attrib_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: alt_allele
--
CREATE TABLE alt_allele (
  alt_allele_id integer(10) unsigned NOT NULL auto_increment,
  alt_allele_group_id integer(10) unsigned NOT NULL,
  gene_id integer(10) unsigned NOT NULL,
  INDEX (gene_id, alt_allele_group_id),
  INDEX (alt_allele_id),
  PRIMARY KEY (alt_allele_id),
  UNIQUE gene_idx (gene_id),
  CONSTRAINT alt_allele_fk FOREIGN KEY (gene_id) REFERENCES gene (gene_id),
  CONSTRAINT alt_allele_fk_1 FOREIGN KEY (alt_allele_group_id) REFERENCES alt_allele_group (alt_allele_group_id),
  CONSTRAINT alt_allele_fk_2 FOREIGN KEY (alt_allele_id) REFERENCES alt_allele (alt_allele_id)
) ENGINE=InnoDB;

--
-- Table: alt_allele_attrib
--
CREATE TABLE alt_allele_attrib (
  alt_allele_id integer(10) unsigned NULL,
  attrib ENUM('IS_REPRESENTATIVE', 'IS_MOST_COMMON_ALLELE', 'IN_CORRECTED_ASSEMBLY', 'HAS_CODING_POTENTIAL', 'IN_ARTIFICIALLY_DUPLICATED_ASSEMBLY', 'IN_SYNTENIC_REGION', 'HAS_SAME_UNDERLYING_DNA_SEQUENCE', 'IN_BROKEN_ASSEMBLY_REGION', 'IS_VALID_ALTERNATE', 'SAME_AS_REPRESENTATIVE', 'SAME_AS_ANOTHER_ALLELE', 'MANUALLY_ASSIGNED', 'AUTOMATICALLY_ASSIGNED') NULL,
  INDEX aa_idx (alt_allele_id, attrib)
) ENGINE=InnoDB;

--
-- Table: alt_allele_group
--
CREATE TABLE alt_allele_group (
  alt_allele_group_id integer(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY (alt_allele_group_id)
) ENGINE=InnoDB;

--
-- Table: analysis
--
CREATE TABLE analysis (
  analysis_id SMALLINT(5) unsigned NOT NULL auto_increment,
  created datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  logic_name VARCHAR(128) NOT NULL,
  db VARCHAR(120) NULL,
  db_version VARCHAR(40) NULL,
  db_file VARCHAR(120) NULL,
  program VARCHAR(80) NULL,
  program_version VARCHAR(40) NULL,
  program_file VARCHAR(80) NULL,
  parameters text NULL,
  module VARCHAR(80) NULL,
  module_version VARCHAR(40) NULL,
  gff_source VARCHAR(40) NULL,
  gff_feature VARCHAR(40) NULL,
  PRIMARY KEY (analysis_id),
  UNIQUE logic_name_idx (logic_name)
) ENGINE=InnoDB;

--
-- Table: analysis_description
--
CREATE TABLE analysis_description (
  analysis_id SMALLINT(5) unsigned NOT NULL,
  description text NULL,
  display_label VARCHAR(255) NOT NULL,
  displayable enum('0','1') NOT NULL DEFAULT '1',
  web_data text NULL,
  INDEX (analysis_id),
  UNIQUE analysis_idx (analysis_id),
  CONSTRAINT analysis_description_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB;

--
-- Table: attrib_type
--
CREATE TABLE attrib_type (
  attrib_type_id SMALLINT(5) unsigned NOT NULL auto_increment,
  code VARCHAR(15) NOT NULL DEFAULT '',
  name VARCHAR(255) NOT NULL DEFAULT '',
  description text NULL,
  PRIMARY KEY (attrib_type_id),
  UNIQUE code_idx (code)
) ENGINE=InnoDB;

--
-- Table: dna_align_feature
--
CREATE TABLE dna_align_feature (
  dna_align_feature_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(1) NOT NULL,
  hit_start integer(11) NOT NULL,
  hit_end integer(11) NOT NULL,
  hit_strand TINYINT(1) NOT NULL,
  hit_name VARCHAR(40) NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  perc_ident FLOAT NULL,
  cigar_line text NULL,
  external_db_id integer(10) unsigned NULL,
  hcoverage DOUBLE NULL,
  external_data text NULL,
  INDEX seq_region_idx (seq_region_id, analysis_id, seq_region_start, score),
  INDEX seq_region_idx_2 (seq_region_id, seq_region_start),
  INDEX hit_idx (hit_name),
  INDEX analysis_idx (analysis_id),
  INDEX external_db_idx (external_db_id),
  INDEX (dna_align_feature_id),
  PRIMARY KEY (dna_align_feature_id),
  CONSTRAINT dna_align_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT dna_align_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT dna_align_feature_fk_2 FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id),
  CONSTRAINT dna_align_feature_fk_3 FOREIGN KEY (dna_align_feature_id) REFERENCES dna_align_feature (dna_align_feature_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80;

--
-- Table: exon
--
CREATE TABLE exon (
  exon_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  phase TINYINT(2) NOT NULL,
  end_phase TINYINT(2) NOT NULL,
  is_current enum('0','1') NOT NULL DEFAULT '1',
  is_constitutive enum('0','1') NOT NULL DEFAULT '0',
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version SMALLINT(5) unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX stable_id_idx (stable_id, version),
  PRIMARY KEY (exon_id),
  CONSTRAINT exon_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: exon_transcript
--
CREATE TABLE exon_transcript (
  exon_id integer(10) unsigned NOT NULL,
  transcript_id integer(10) unsigned NOT NULL,
  rank integer(10) NOT NULL,
  INDEX transcript (transcript_id),
  INDEX exon (exon_id),
  PRIMARY KEY (exon_id, transcript_id, rank),
  CONSTRAINT exon_transcript_fk FOREIGN KEY (exon_id) REFERENCES exon (exon_id),
  CONSTRAINT exon_transcript_fk_1 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB;

--
-- Table: gene
--
CREATE TABLE gene (
  gene_id integer(10) unsigned NOT NULL auto_increment,
  biotype VARCHAR(40) NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  display_xref_id integer(10) unsigned NULL,
  source VARCHAR(20) NOT NULL,
  status ENUM('KNOWN', 'NOVEL', 'PUTATIVE', 'PREDICTED', 'KNOWN_BY_PROJECTION', 'UNKNOWN', 'ANNOTATED') NULL,
  description text NULL,
  is_current enum('0','1') NOT NULL DEFAULT '1',
  canonical_transcript_id integer(10) unsigned NOT NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version SMALLINT(5) unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX xref_id_index (display_xref_id),
  INDEX analysis_idx (analysis_id),
  INDEX stable_id_idx (stable_id, version),
  INDEX canonical_transcript_id_idx (canonical_transcript_id),
  PRIMARY KEY (gene_id),
  CONSTRAINT gene_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT gene_fk_1 FOREIGN KEY (display_xref_id) REFERENCES xref (xref_id),
  CONSTRAINT gene_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT gene_fk_3 FOREIGN KEY (canonical_transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB;

--
-- Table: gene_attrib
--
CREATE TABLE gene_attrib (
  gene_id integer(10) unsigned NOT NULL DEFAULT 0,
  attrib_type_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  value varchar(255) NOT NULL,
  INDEX type_val_idx (attrib_type_id, value),
  INDEX val_only_idx (value),
  INDEX gene_idx (gene_id),
  CONSTRAINT gene_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT gene_attrib_fk_1 FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB;

--
-- Table: protein_align_feature
--
CREATE TABLE protein_align_feature (
  protein_align_feature_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(1) NOT NULL DEFAULT 1,
  hit_start integer(10) NOT NULL,
  hit_end integer(10) NOT NULL,
  hit_name VARCHAR(40) NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  perc_ident FLOAT NULL,
  cigar_line text NULL,
  external_db_id integer(10) unsigned NULL,
  hcoverage DOUBLE NULL,
  INDEX seq_region_idx (seq_region_id, analysis_id, seq_region_start, score),
  INDEX seq_region_idx_2 (seq_region_id, seq_region_start),
  INDEX hit_idx (hit_name),
  INDEX analysis_idx (analysis_id),
  INDEX external_db_idx (external_db_id),
  PRIMARY KEY (protein_align_feature_id),
  CONSTRAINT protein_align_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT protein_align_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT protein_align_feature_fk_2 FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80;

--
-- Table: protein_feature
--
CREATE TABLE protein_feature (
  protein_feature_id integer(10) unsigned NOT NULL auto_increment,
  translation_id integer(10) unsigned NOT NULL,
  seq_start integer(10) NOT NULL,
  seq_end integer(10) NOT NULL,
  hit_start integer(10) NOT NULL,
  hit_end integer(10) NOT NULL,
  hit_name VARCHAR(40) NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  perc_ident FLOAT NULL,
  external_data text NULL,
  hit_description text NULL,
  INDEX translation_idx (translation_id),
  INDEX hitname_idx (hit_name),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (protein_feature_id),
  CONSTRAINT protein_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT protein_feature_fk_1 FOREIGN KEY (translation_id) REFERENCES translation (translation_id)
) ENGINE=InnoDB;

--
-- Table: splicing_event
--
CREATE TABLE splicing_event (
  splicing_event_id integer(10) unsigned NOT NULL auto_increment,
  name VARCHAR(134) NULL,
  gene_id integer(10) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  attrib_type_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  INDEX gene_idx (gene_id),
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  PRIMARY KEY (splicing_event_id),
  CONSTRAINT splicing_event_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT splicing_event_fk_1 FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB;

--
-- Table: splicing_event_feature
--
CREATE TABLE splicing_event_feature (
  splicing_event_feature_id integer(10) unsigned NOT NULL,
  splicing_event_id integer(10) unsigned NOT NULL,
  exon_id integer(10) unsigned NOT NULL,
  transcript_id integer(10) unsigned NOT NULL,
  feature_order integer(10) unsigned NOT NULL,
  transcript_association integer(10) unsigned NOT NULL,
  type ENUM('constitutive_exon', 'exon', 'flanking_exon') NULL,
  start integer(10) unsigned NOT NULL,
  end integer(10) unsigned NOT NULL,
  INDEX se_idx (splicing_event_id),
  INDEX transcript_idx (transcript_id),
  INDEX (exon_id),
  PRIMARY KEY (splicing_event_feature_id, exon_id, transcript_id),
  CONSTRAINT splicing_event_feature_fk FOREIGN KEY (splicing_event_id) REFERENCES splicing_event (splicing_event_id),
  CONSTRAINT splicing_event_feature_fk_1 FOREIGN KEY (exon_id) REFERENCES exon (exon_id),
  CONSTRAINT splicing_event_feature_fk_2 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB;

--
-- Table: splicing_transcript_pair
--
CREATE TABLE splicing_transcript_pair (
  splicing_transcript_pair_id integer(10) unsigned NOT NULL,
  splicing_event_id integer(10) unsigned NOT NULL,
  transcript_id_1 integer(10) unsigned NOT NULL,
  transcript_id_2 integer(10) unsigned NOT NULL,
  INDEX se_idx (splicing_event_id),
  INDEX (transcript_id_1),
  INDEX (transcript_id_2),
  PRIMARY KEY (splicing_transcript_pair_id),
  CONSTRAINT splicing_transcript_pair_fk FOREIGN KEY (splicing_event_id) REFERENCES splicing_event (splicing_event_id),
  CONSTRAINT splicing_transcript_pair_fk_1 FOREIGN KEY (transcript_id_1) REFERENCES transcript (transcript_id),
  CONSTRAINT splicing_transcript_pair_fk_2 FOREIGN KEY (transcript_id_2) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB;

--
-- Table: supporting_feature
--
CREATE TABLE supporting_feature (
  exon_id integer(10) unsigned NOT NULL DEFAULT 0,
  feature_type ENUM('dna_align_feature', 'protein_align_feature') NULL,
  feature_id integer(10) unsigned NOT NULL DEFAULT 0,
  INDEX feature_idx (feature_type, feature_id),
  INDEX (exon_id),
  UNIQUE all_idx (exon_id, feature_type, feature_id),
  CONSTRAINT supporting_feature_fk FOREIGN KEY (exon_id) REFERENCES exon (exon_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80;

--
-- Table: transcript
--
CREATE TABLE transcript (
  transcript_id integer(10) unsigned NOT NULL auto_increment,
  gene_id integer(10) unsigned NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  display_xref_id integer(10) unsigned NULL,
  biotype VARCHAR(40) NOT NULL,
  status ENUM('KNOWN', 'NOVEL', 'PUTATIVE', 'PREDICTED', 'KNOWN_BY_PROJECTION', 'UNKNOWN', 'ANNOTATED') NULL,
  description text NULL,
  is_current enum('0','1') NOT NULL DEFAULT '1',
  canonical_translation_id integer(10) unsigned NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version SMALLINT(5) unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX gene_index (gene_id),
  INDEX xref_id_index (display_xref_id),
  INDEX analysis_idx (analysis_id),
  INDEX stable_id_idx (stable_id, version),
  INDEX (canonical_translation_id),
  PRIMARY KEY (transcript_id),
  UNIQUE canonical_translation_idx (canonical_translation_id),
  CONSTRAINT transcript_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT transcript_fk_1 FOREIGN KEY (display_xref_id) REFERENCES xref (xref_id),
  CONSTRAINT transcript_fk_2 FOREIGN KEY (gene_id) REFERENCES gene (gene_id),
  CONSTRAINT transcript_fk_3 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT transcript_fk_4 FOREIGN KEY (canonical_translation_id) REFERENCES translation (translation_id)
) ENGINE=InnoDB;

--
-- Table: transcript_attrib
--
CREATE TABLE transcript_attrib (
  transcript_id integer(10) unsigned NOT NULL DEFAULT 0,
  attrib_type_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  value varchar(255) NOT NULL,
  INDEX type_val_idx (attrib_type_id, value),
  INDEX val_only_idx (value),
  INDEX transcript_idx (transcript_id),
  CONSTRAINT transcript_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT transcript_attrib_fk_1 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB;

--
-- Table: transcript_supporting_feature
--
CREATE TABLE transcript_supporting_feature (
  transcript_id integer(10) unsigned NOT NULL DEFAULT 0,
  feature_type ENUM('dna_align_feature', 'protein_align_feature') NULL,
  feature_id integer(10) unsigned NOT NULL DEFAULT 0,
  INDEX feature_idx (feature_type, feature_id),
  INDEX (transcript_id),
  UNIQUE all_idx (transcript_id, feature_type, feature_id),
  CONSTRAINT transcript_supporting_feature_fk FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80;

--
-- Table: translation
--
CREATE TABLE translation (
  translation_id integer(10) unsigned NOT NULL auto_increment,
  transcript_id integer(10) unsigned NOT NULL,
  seq_start integer(10) NOT NULL,
  start_exon_id integer(10) unsigned NOT NULL comment 'relative to exon start',
  seq_end integer(10) NOT NULL,
  end_exon_id integer(10) unsigned NOT NULL comment 'relative to exon start',
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version SMALLINT(5) unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX transcript_idx (transcript_id),
  INDEX stable_id_idx (stable_id, version),
  INDEX (end_exon_id),
  INDEX (start_exon_id),
  PRIMARY KEY (translation_id),
  CONSTRAINT translation_fk FOREIGN KEY (end_exon_id) REFERENCES exon (exon_id),
  CONSTRAINT translation_fk_1 FOREIGN KEY (start_exon_id) REFERENCES exon (exon_id),
  CONSTRAINT translation_fk_2 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB;

--
-- Table: translation_attrib
--
CREATE TABLE translation_attrib (
  translation_id integer(10) unsigned NOT NULL DEFAULT 0,
  attrib_type_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  value varchar(255) NOT NULL,
  INDEX type_val_idx (attrib_type_id, value),
  INDEX val_only_idx (value),
  INDEX translation_idx (translation_id),
  CONSTRAINT translation_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT translation_attrib_fk_1 FOREIGN KEY (translation_id) REFERENCES translation (translation_id)
) ENGINE=InnoDB;

--
-- Table: density_feature
--
CREATE TABLE density_feature (
  density_feature_id integer(10) unsigned NOT NULL auto_increment,
  density_type_id integer(10) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  density_value FLOAT NOT NULL,
  INDEX seq_region_idx (density_type_id, seq_region_id, seq_region_start),
  INDEX seq_region_id_idx (seq_region_id),
  PRIMARY KEY (density_feature_id),
  CONSTRAINT density_feature_fk FOREIGN KEY (density_type_id) REFERENCES density_type (density_type_id),
  CONSTRAINT density_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: density_type
--
CREATE TABLE density_type (
  density_type_id integer(10) unsigned NOT NULL auto_increment,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  block_size integer(11) NOT NULL,
  region_features integer(11) NOT NULL,
  value_type ENUM('sum', 'ratio') NOT NULL,
  INDEX (analysis_id),
  PRIMARY KEY (density_type_id),
  UNIQUE analysis_idx (analysis_id, block_size, region_features),
  CONSTRAINT density_type_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB;

--
-- Table: ditag
--
CREATE TABLE ditag (
  ditag_id integer(10) unsigned NOT NULL auto_increment,
  name VARCHAR(30) NOT NULL,
  type VARCHAR(30) NOT NULL,
  tag_count smallint(6) unsigned NOT NULL DEFAULT 1,
  sequence TINYTEXT NOT NULL,
  PRIMARY KEY (ditag_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

--
-- Table: ditag_feature
--
CREATE TABLE ditag_feature (
  ditag_feature_id integer(10) unsigned NOT NULL auto_increment,
  ditag_id integer(10) unsigned NOT NULL DEFAULT 0,
  ditag_pair_id integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_id integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_start integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_end integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_strand TINYINT(1) NOT NULL DEFAULT 0,
  analysis_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  hit_start integer(10) unsigned NOT NULL DEFAULT 0,
  hit_end integer(10) unsigned NOT NULL DEFAULT 0,
  hit_strand TINYINT(1) NOT NULL DEFAULT 0,
  cigar_line TINYTEXT NOT NULL,
  ditag_side ENUM('F', 'L', 'R') NOT NULL,
  INDEX ditag_idx (ditag_id),
  INDEX ditag_pair_idx (ditag_pair_id),
  INDEX seq_region_idx (seq_region_id, seq_region_start, seq_region_end),
  INDEX (analysis_id),
  PRIMARY KEY (ditag_feature_id),
  CONSTRAINT ditag_feature_fk FOREIGN KEY (ditag_id) REFERENCES ditag (ditag_id),
  CONSTRAINT ditag_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT ditag_feature_fk_2 FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

--
-- Table: intron_supporting_evidence
--
CREATE TABLE intron_supporting_evidence (
  intron_supporting_evidence_id integer(10) unsigned NOT NULL auto_increment,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  hit_name VARCHAR(100) NOT NULL,
  score DECIMAL(10, 3) NULL,
  score_type ENUM('NONE', 'DEPTH') NULL DEFAULT 'NONE',
  is_splice_canonical enum('0','1') NOT NULL DEFAULT '0',
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX (analysis_id),
  PRIMARY KEY (intron_supporting_evidence_id),
  UNIQUE (analysis_id, seq_region_id, seq_region_start, seq_region_end, seq_region_strand, hit_name),
  CONSTRAINT intron_supporting_evidence_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT intron_supporting_evidence_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: map
--
CREATE TABLE map (
  map_id integer(10) unsigned NOT NULL auto_increment,
  map_name VARCHAR(30) NOT NULL,
  PRIMARY KEY (map_id)
) ENGINE=InnoDB;

--
-- Table: marker
--
CREATE TABLE marker (
  marker_id integer(10) unsigned NOT NULL auto_increment,
  display_marker_synonym_id integer(10) unsigned NULL,
  left_primer VARCHAR(100) NOT NULL,
  right_primer VARCHAR(100) NOT NULL,
  min_primer_dist integer(10) unsigned NOT NULL,
  max_primer_dist integer(10) unsigned NOT NULL,
  priority integer(11) NULL,
  type ENUM('est', 'microsatellite') NULL,
  INDEX marker_idx (marker_id, priority),
  INDEX display_idx (display_marker_synonym_id),
  PRIMARY KEY (marker_id),
  CONSTRAINT marker_fk FOREIGN KEY (display_marker_synonym_id) REFERENCES marker_synonym (marker_synonym_id)
) ENGINE=InnoDB;

--
-- Table: marker_feature
--
CREATE TABLE marker_feature (
  marker_feature_id integer(10) unsigned NOT NULL auto_increment,
  marker_id integer(10) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  map_weight integer(10) unsigned NULL,
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX analysis_idx (analysis_id),
  INDEX (marker_id),
  PRIMARY KEY (marker_feature_id),
  CONSTRAINT marker_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT marker_feature_fk_1 FOREIGN KEY (marker_id) REFERENCES marker (marker_id),
  CONSTRAINT marker_feature_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: marker_map_location
--
CREATE TABLE marker_map_location (
  marker_id integer(10) unsigned NOT NULL,
  map_id integer(10) unsigned NOT NULL,
  chromosome_name VARCHAR(15) NOT NULL,
  marker_synonym_id integer(10) unsigned NOT NULL,
  position VARCHAR(15) NOT NULL,
  lod_score DOUBLE NULL,
  INDEX map_idx (map_id, chromosome_name, position),
  INDEX (marker_id),
  INDEX (marker_synonym_id),
  PRIMARY KEY (marker_id, map_id),
  CONSTRAINT marker_map_location_fk FOREIGN KEY (map_id) REFERENCES map (map_id),
  CONSTRAINT marker_map_location_fk_1 FOREIGN KEY (marker_id) REFERENCES marker (marker_id),
  CONSTRAINT marker_map_location_fk_2 FOREIGN KEY (marker_synonym_id) REFERENCES marker_synonym (marker_synonym_id)
) ENGINE=InnoDB;

--
-- Table: marker_synonym
--
CREATE TABLE marker_synonym (
  marker_synonym_id integer(10) unsigned NOT NULL auto_increment,
  marker_id integer(10) unsigned NOT NULL,
  source VARCHAR(20) NULL,
  name VARCHAR(50) NULL,
  INDEX marker_synonym_idx (marker_synonym_id, name),
  INDEX marker_idx (marker_id),
  PRIMARY KEY (marker_synonym_id),
  CONSTRAINT marker_synonym_fk FOREIGN KEY (marker_id) REFERENCES marker (marker_id)
) ENGINE=InnoDB;

--
-- Table: misc_attrib
--
CREATE TABLE misc_attrib (
  misc_feature_id integer(10) unsigned NOT NULL DEFAULT 0,
  attrib_type_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  value varchar(255) NOT NULL,
  INDEX type_val_idx (attrib_type_id, value),
  INDEX val_only_idx (value),
  INDEX misc_feature_idx (misc_feature_id),
  CONSTRAINT misc_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT misc_attrib_fk_1 FOREIGN KEY (misc_feature_id) REFERENCES misc_feature (misc_feature_id)
) ENGINE=InnoDB;

--
-- Table: misc_feature
--
CREATE TABLE misc_feature (
  misc_feature_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_start integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_end integer(10) unsigned NOT NULL DEFAULT 0,
  seq_region_strand TINYINT(4) NOT NULL DEFAULT 0,
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  PRIMARY KEY (misc_feature_id),
  CONSTRAINT misc_feature_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: misc_feature_misc_set
--
CREATE TABLE misc_feature_misc_set (
  misc_feature_id integer(10) unsigned NOT NULL DEFAULT 0,
  misc_set_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  INDEX reverse_idx (misc_set_id, misc_feature_id),
  PRIMARY KEY (misc_feature_id, misc_set_id),
  CONSTRAINT misc_feature_misc_set_fk FOREIGN KEY (misc_feature_id) REFERENCES misc_feature (misc_feature_id),
  CONSTRAINT misc_feature_misc_set_fk_1 FOREIGN KEY (misc_set_id) REFERENCES misc_set (misc_set_id)
) ENGINE=InnoDB;

--
-- Table: misc_set
--
CREATE TABLE misc_set (
  misc_set_id SMALLINT(5) unsigned NOT NULL auto_increment,
  code VARCHAR(25) NOT NULL DEFAULT '',
  name VARCHAR(255) NOT NULL DEFAULT '',
  description text NOT NULL,
  max_length integer(10) unsigned NOT NULL,
  PRIMARY KEY (misc_set_id),
  UNIQUE code_idx (code)
) ENGINE=InnoDB;

--
-- Table: prediction_exon
--
CREATE TABLE prediction_exon (
  prediction_exon_id integer(10) unsigned NOT NULL auto_increment,
  prediction_transcript_id integer(10) unsigned NOT NULL,
  exon_rank SMALLINT(5) unsigned NOT NULL,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  start_phase TINYINT(4) NOT NULL,
  score DOUBLE NULL,
  p_value DOUBLE NULL,
  INDEX transcript_idx (prediction_transcript_id),
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  PRIMARY KEY (prediction_exon_id),
  CONSTRAINT prediction_exon_fk FOREIGN KEY (prediction_transcript_id) REFERENCES prediction_transcript (prediction_transcript_id),
  CONSTRAINT prediction_exon_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: prediction_transcript
--
CREATE TABLE prediction_transcript (
  prediction_transcript_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  display_label VARCHAR(255) NULL,
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (prediction_transcript_id),
  CONSTRAINT prediction_transcript_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT prediction_transcript_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: repeat_consensus
--
CREATE TABLE repeat_consensus (
  repeat_consensus_id integer(10) unsigned NOT NULL auto_increment,
  repeat_name VARCHAR(255) NOT NULL,
  repeat_class VARCHAR(100) NOT NULL,
  repeat_type VARCHAR(40) NOT NULL,
  repeat_consensus text NULL,
  INDEX name (repeat_name),
  INDEX class (repeat_class),
  INDEX consensus (repeat_consensus(10)),
  INDEX type (repeat_type),
  PRIMARY KEY (repeat_consensus_id)
) ENGINE=InnoDB;

--
-- Table: repeat_feature
--
CREATE TABLE repeat_feature (
  repeat_feature_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(1) NOT NULL DEFAULT 1,
  repeat_start integer(10) NOT NULL,
  repeat_end integer(10) NOT NULL,
  repeat_consensus_id integer(10) unsigned NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  score DOUBLE NULL,
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX repeat_idx (repeat_consensus_id),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (repeat_feature_id),
  CONSTRAINT repeat_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT repeat_feature_fk_1 FOREIGN KEY (repeat_consensus_id) REFERENCES repeat_consensus (repeat_consensus_id),
  CONSTRAINT repeat_feature_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80;

--
-- Table: simple_feature
--
CREATE TABLE simple_feature (
  simple_feature_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(1) NOT NULL,
  display_label VARCHAR(255) NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  score DOUBLE NULL,
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX analysis_idx (analysis_id),
  INDEX hit_idx (display_label),
  PRIMARY KEY (simple_feature_id),
  CONSTRAINT simple_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT simple_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

--
-- Table: transcript_intron_supporting_evidence
--
CREATE TABLE transcript_intron_supporting_evidence (
  transcript_id integer(10) unsigned NOT NULL,
  intron_supporting_evidence_id integer(10) unsigned NOT NULL,
  previous_exon_id integer(10) unsigned NOT NULL,
  next_exon_id integer(10) unsigned NOT NULL,
  INDEX transcript_idx (transcript_id),
  PRIMARY KEY (intron_supporting_evidence_id, transcript_id)
) ENGINE=InnoDB;

--
-- Table: gene_archive
--
CREATE TABLE gene_archive (
  gene_stable_id VARCHAR(128) NOT NULL,
  gene_version SMALLINT(6) NOT NULL DEFAULT 1,
  transcript_stable_id VARCHAR(128) NOT NULL,
  transcript_version SMALLINT(6) NOT NULL DEFAULT 1,
  translation_stable_id VARCHAR(128) NULL,
  translation_version SMALLINT(6) NOT NULL DEFAULT 1,
  peptide_archive_id integer(10) unsigned NULL,
  mapping_session_id integer(10) unsigned NOT NULL,
  INDEX gene_idx (gene_stable_id, gene_version),
  INDEX transcript_idx (transcript_stable_id, transcript_version),
  INDEX translation_idx (translation_stable_id, translation_version),
  INDEX peptide_archive_id_idx (peptide_archive_id),
  INDEX (mapping_session_id),
  CONSTRAINT gene_archive_fk FOREIGN KEY (mapping_session_id) REFERENCES mapping_session (mapping_session_id),
  CONSTRAINT gene_archive_fk_1 FOREIGN KEY (peptide_archive_id) REFERENCES peptide_archive (peptide_archive_id)
) ENGINE=InnoDB;

--
-- Table: mapping_session
--
CREATE TABLE mapping_session (
  mapping_session_id integer(10) unsigned NOT NULL auto_increment,
  old_db_name VARCHAR(80) NOT NULL DEFAULT '',
  new_db_name VARCHAR(80) NOT NULL DEFAULT '',
  old_release VARCHAR(5) NOT NULL DEFAULT '',
  new_release VARCHAR(5) NOT NULL DEFAULT '',
  old_assembly VARCHAR(20) NOT NULL DEFAULT '',
  new_assembly VARCHAR(20) NOT NULL DEFAULT '',
  created datetime NOT NULL,
  PRIMARY KEY (mapping_session_id)
) ENGINE=InnoDB;

--
-- Table: peptide_archive
--
CREATE TABLE peptide_archive (
  peptide_archive_id integer(10) unsigned NOT NULL auto_increment,
  md5_checksum VARCHAR(32) NULL,
  peptide_seq MEDIUMTEXT NOT NULL,
  INDEX checksum (md5_checksum),
  PRIMARY KEY (peptide_archive_id)
) ENGINE=InnoDB;

--
-- Table: mapping_set
--
CREATE TABLE mapping_set (
  mapping_set_id integer(10) unsigned NOT NULL,
  internal_schema_build VARCHAR(20) NOT NULL,
  external_schema_build VARCHAR(20) NOT NULL,
  PRIMARY KEY (mapping_set_id),
  UNIQUE mapping_idx (internal_schema_build, external_schema_build)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

--
-- Table: stable_id_event
--
CREATE TABLE stable_id_event (
  old_stable_id VARCHAR(128) NULL,
  old_version SMALLINT(6) NULL,
  new_stable_id VARCHAR(128) NULL,
  new_version SMALLINT(6) NULL,
  mapping_session_id integer(10) unsigned NOT NULL DEFAULT 0,
  type ENUM('gene', 'transcript', 'translation') NOT NULL,
  score FLOAT NOT NULL DEFAULT 0,
  INDEX new_idx (new_stable_id),
  INDEX old_idx (old_stable_id),
  INDEX (mapping_session_id),
  UNIQUE uni_idx (mapping_session_id, old_stable_id, new_stable_id, type),
  CONSTRAINT stable_id_event_fk FOREIGN KEY (mapping_session_id) REFERENCES mapping_session (mapping_session_id)
) ENGINE=InnoDB;

--
-- Table: seq_region_mapping
--
CREATE TABLE seq_region_mapping (
  external_seq_region_id integer(10) unsigned NOT NULL,
  internal_seq_region_id integer(10) unsigned NOT NULL,
  mapping_set_id integer(10) unsigned NOT NULL,
  INDEX mapping_set_idx (mapping_set_id),
  INDEX (internal_seq_region_id),
  CONSTRAINT seq_region_mapping_fk FOREIGN KEY (internal_seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT seq_region_mapping_fk_1 FOREIGN KEY (mapping_set_id) REFERENCES mapping_set (mapping_set_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

--
-- Table: associated_group
--
CREATE TABLE associated_group (
  associated_group_id integer(10) unsigned NOT NULL auto_increment,
  description VARCHAR(128) NULL DEFAULT NULL,
  PRIMARY KEY (associated_group_id)
) ENGINE=InnoDB;

--
-- Table: associated_xref
--
CREATE TABLE associated_xref (
  associated_xref_id integer(10) unsigned NOT NULL auto_increment,
  object_xref_id integer(10) unsigned NOT NULL DEFAULT 0,
  xref_id integer(10) unsigned NOT NULL DEFAULT 0,
  source_xref_id integer(10) unsigned NULL DEFAULT NULL,
  condition_type VARCHAR(128) NULL DEFAULT NULL,
  associated_group_id integer(10) unsigned NULL DEFAULT NULL,
  rank integer(10) unsigned NULL DEFAULT 0,
  INDEX associated_source_idx (source_xref_id),
  INDEX associated_object_idx (object_xref_id),
  INDEX associated_idx (xref_id),
  INDEX associated_group_idx (associated_group_id),
  PRIMARY KEY (associated_xref_id),
  UNIQUE object_associated_source_type_idx (object_xref_id, xref_id, source_xref_id, condition_type, associated_group_id),
  CONSTRAINT associated_xref_fk FOREIGN KEY (associated_group_id) REFERENCES associated_group (associated_group_id)
) ENGINE=InnoDB;

--
-- Table: dependent_xref
--
CREATE TABLE dependent_xref (
  object_xref_id integer(10) unsigned NOT NULL,
  master_xref_id integer(10) unsigned NOT NULL,
  dependent_xref_id integer(10) unsigned NOT NULL,
  INDEX dependent (dependent_xref_id),
  INDEX master_idx (master_xref_id),
  INDEX (object_xref_id),
  PRIMARY KEY (object_xref_id),
  CONSTRAINT dependent_xref_fk FOREIGN KEY (object_xref_id) REFERENCES object_xref (object_xref_id),
  CONSTRAINT dependent_xref_fk_1 FOREIGN KEY (master_xref_id) REFERENCES xref (xref_id),
  CONSTRAINT dependent_xref_fk_2 FOREIGN KEY (dependent_xref_id) REFERENCES xref (xref_id)
) ENGINE=InnoDB;

--
-- Table: external_db
--
CREATE TABLE external_db (
  external_db_id integer(10) unsigned NOT NULL auto_increment,
  db_name VARCHAR(100) NOT NULL,
  db_release VARCHAR(255) NULL,
  status ENUM('KNOWNXREF', 'KNOWN', 'XREF', 'PRED', 'ORTH', 'PSEUDO') NOT NULL,
  priority integer(11) NOT NULL,
  db_display_name VARCHAR(255) NULL,
  type ENUM('ARRAY', 'ALT_TRANS', 'ALT_GENE', 'MISC', 'LIT', 'PRIMARY_DB_SYNONYM', 'ENSEMBL') NULL,
  secondary_db_name VARCHAR(255) NULL DEFAULT NULL,
  secondary_db_table VARCHAR(255) NULL DEFAULT NULL,
  description text NULL,
  PRIMARY KEY (external_db_id),
  UNIQUE db_name_db_release_idx (db_name, db_release)
) ENGINE=InnoDB;

--
-- Table: external_synonym
--
CREATE TABLE external_synonym (
  xref_id integer(10) unsigned NOT NULL,
  synonym VARCHAR(100) NOT NULL,
  INDEX name_index (synonym),
  INDEX (xref_id),
  PRIMARY KEY (xref_id, synonym),
  CONSTRAINT external_synonym_fk FOREIGN KEY (xref_id) REFERENCES xref (xref_id)
) ENGINE=InnoDB;

--
-- Table: identity_xref
--
CREATE TABLE identity_xref (
  object_xref_id integer(10) unsigned NOT NULL,
  xref_identity integer(5) NULL,
  ensembl_identity integer(5) NULL,
  xref_start integer(11) NULL,
  xref_end integer(11) NULL,
  ensembl_start integer(11) NULL,
  ensembl_end integer(11) NULL,
  cigar_line text NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  INDEX (object_xref_id),
  PRIMARY KEY (object_xref_id),
  CONSTRAINT identity_xref_fk FOREIGN KEY (object_xref_id) REFERENCES object_xref (object_xref_id)
) ENGINE=InnoDB;

--
-- Table: interpro
--
CREATE TABLE interpro (
  interpro_ac VARCHAR(40) NOT NULL,
  id VARCHAR(40) NOT NULL,
  INDEX id_idx (id),
  UNIQUE accession_idx (interpro_ac, id)
) ENGINE=InnoDB;

--
-- Table: object_xref
--
CREATE TABLE object_xref (
  object_xref_id integer(10) unsigned NOT NULL auto_increment,
  ensembl_id integer(10) unsigned NOT NULL,
  ensembl_object_type ENUM('RawContig', 'Transcript', 'Gene', 'Translation', 'Operon', 'OperonTranscript', 'Marker') NOT NULL,
  xref_id integer(10) unsigned NOT NULL,
  linkage_annotation VARCHAR(255) NULL DEFAULT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL DEFAULT 0,
  INDEX ensembl_idx (ensembl_object_type, ensembl_id),
  INDEX analysis_idx (analysis_id),
  INDEX (xref_id),
  PRIMARY KEY (object_xref_id),
  UNIQUE xref_idx (xref_id, ensembl_object_type, ensembl_id, analysis_id),
  CONSTRAINT object_xref_fk FOREIGN KEY (xref_id) REFERENCES xref (xref_id),
  CONSTRAINT object_xref_fk_1 FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB;

--
-- Table: ontology_xref
--
CREATE TABLE ontology_xref (
  object_xref_id integer(10) unsigned NOT NULL DEFAULT 0,
  source_xref_id integer(10) unsigned NULL DEFAULT NULL,
  linkage_type VARCHAR(3) NULL DEFAULT NULL,
  INDEX source_idx (source_xref_id),
  INDEX object_idx (object_xref_id),
  UNIQUE object_source_type_idx (object_xref_id, source_xref_id, linkage_type),
  CONSTRAINT ontology_xref_fk FOREIGN KEY (object_xref_id) REFERENCES object_xref (object_xref_id),
  CONSTRAINT ontology_xref_fk_1 FOREIGN KEY (source_xref_id) REFERENCES xref (xref_id)
) ENGINE=InnoDB;

--
-- Table: unmapped_object
--
CREATE TABLE unmapped_object (
  unmapped_object_id integer(10) unsigned NOT NULL auto_increment,
  type ENUM('xref', 'cDNA', 'Marker') NOT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  external_db_id integer(10) unsigned NULL,
  identifier VARCHAR(255) NOT NULL,
  unmapped_reason_id SMALLINT(5) unsigned NOT NULL,
  query_score DOUBLE NULL,
  target_score DOUBLE NULL,
  ensembl_id integer(10) unsigned NULL DEFAULT 0,
  ensembl_object_type ENUM('RawContig', 'Transcript', 'Gene', 'Translation') NULL DEFAULT 'RawContig',
  parent VARCHAR(255) NULL DEFAULT NULL,
  INDEX id_idx (identifier(50)),
  INDEX anal_exdb_idx (analysis_id, external_db_id),
  INDEX ext_db_identifier_idx (external_db_id, identifier),
  INDEX (unmapped_reason_id),
  PRIMARY KEY (unmapped_object_id),
  UNIQUE unique_unmapped_obj_idx (ensembl_id, ensembl_object_type, identifier, unmapped_reason_id, parent, external_db_id),
  CONSTRAINT unmapped_object_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT unmapped_object_fk_1 FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id),
  CONSTRAINT unmapped_object_fk_2 FOREIGN KEY (unmapped_reason_id) REFERENCES unmapped_reason (unmapped_reason_id)
) ENGINE=InnoDB;

--
-- Table: unmapped_reason
--
CREATE TABLE unmapped_reason (
  unmapped_reason_id SMALLINT(5) unsigned NOT NULL auto_increment,
  summary_description VARCHAR(255) NULL,
  full_description VARCHAR(255) NULL,
  PRIMARY KEY (unmapped_reason_id)
) ENGINE=InnoDB;

--
-- Table: xref
--
CREATE TABLE xref (
  xref_id integer(10) unsigned NOT NULL auto_increment,
  external_db_id integer(10) unsigned NOT NULL,
  dbprimary_acc VARCHAR(40) NOT NULL,
  display_label VARCHAR(128) NOT NULL,
  version VARCHAR(10) NOT NULL DEFAULT '0',
  description text NULL,
  info_type ENUM('NONE', 'PROJECTION', 'MISC', 'DEPENDENT', 'DIRECT', 'SEQUENCE_MATCH', 'INFERRED_PAIR', 'PROBE', 'UNMAPPED', 'COORDINATE_OVERLAP', 'CHECKSUM') NOT NULL DEFAULT 'NONE',
  info_text VARCHAR(255) NOT NULL DEFAULT '',
  INDEX display_index (display_label),
  INDEX info_type_idx (info_type),
  INDEX (external_db_id),
  PRIMARY KEY (xref_id),
  UNIQUE id_index (dbprimary_acc, external_db_id, info_type, info_text, version),
  CONSTRAINT xref_fk FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id)
) ENGINE=InnoDB;

--
-- Table: operon
--
CREATE TABLE operon (
  operon_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  display_label VARCHAR(255) NULL DEFAULT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version SMALLINT(5) unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX name_idx (display_label),
  INDEX stable_id_idx (stable_id, version),
  INDEX (analysis_id),
  PRIMARY KEY (operon_id),
  CONSTRAINT operon_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT operon_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB;

--
-- Table: operon_transcript
--
CREATE TABLE operon_transcript (
  operon_transcript_id integer(10) unsigned NOT NULL auto_increment,
  seq_region_id integer(10) unsigned NOT NULL,
  seq_region_start integer(10) unsigned NOT NULL,
  seq_region_end integer(10) unsigned NOT NULL,
  seq_region_strand TINYINT(2) NOT NULL,
  operon_id integer(10) unsigned NOT NULL,
  display_label VARCHAR(255) NULL DEFAULT NULL,
  analysis_id SMALLINT(5) unsigned NOT NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version SMALLINT(5) unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX operon_idx (operon_id),
  INDEX seq_region_idx (seq_region_id, seq_region_start),
  INDEX stable_id_idx (stable_id, version),
  INDEX (analysis_id),
  PRIMARY KEY (operon_transcript_id),
  CONSTRAINT operon_transcript_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT operon_transcript_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT operon_transcript_fk_2 FOREIGN KEY (operon_id) REFERENCES operon (operon_id)
) ENGINE=InnoDB;

--
-- Table: operon_transcript_gene
--
CREATE TABLE operon_transcript_gene (
  operon_transcript_id integer(10) unsigned NULL,
  gene_id integer(10) unsigned NULL,
  INDEX operon_transcript_gene_idx (operon_transcript_id, gene_id),
  CONSTRAINT operon_transcript_gene_fk FOREIGN KEY (operon_transcript_id) REFERENCES operon_transcript (operon_transcript_id),
  CONSTRAINT operon_transcript_gene_fk_1 FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

