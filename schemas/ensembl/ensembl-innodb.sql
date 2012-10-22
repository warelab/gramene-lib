SET foreign_key_checks=0;

DROP TABLE IF EXISTS exon_transcript;

--
-- Table: exon_transcript
--
CREATE TABLE exon_transcript (
  exon_id integer unsigned NOT NULL,
  transcript_id integer unsigned NOT NULL,
  rank integer NOT NULL,
  INDEX transcript (transcript_id),
  INDEX exon (exon_id),
  PRIMARY KEY (exon_id, transcript_id, rank),
  CONSTRAINT exon_transcript_fk FOREIGN KEY (exon_id) REFERENCES exon (exon_id),
  CONSTRAINT exon_transcript_fk_1 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS ditag_feature;

--
-- Table: ditag_feature
--
CREATE TABLE ditag_feature (
  ditag_feature_id integer unsigned NOT NULL auto_increment,
  ditag_id integer unsigned NOT NULL DEFAULT 0,
  ditag_pair_id integer unsigned NOT NULL DEFAULT 0,
  seq_region_id integer unsigned NOT NULL DEFAULT 0,
  seq_region_start integer unsigned NOT NULL DEFAULT 0,
  seq_region_end integer unsigned NOT NULL DEFAULT 0,
  seq_region_strand TINYINT(4) NOT NULL DEFAULT 0,
  analysis_id integer unsigned NOT NULL DEFAULT 0,
  hit_start integer unsigned NOT NULL DEFAULT 0,
  hit_end integer unsigned NOT NULL DEFAULT 0,
  hit_strand TINYINT(4) NOT NULL DEFAULT 0,
  cigar_line TINYTEXT NOT NULL,
  ditag_side ENUM('F', 'L', 'R') NOT NULL,
  INDEX ditag_idx (ditag_id),
  INDEX ditag_pair_idx (ditag_pair_id),
  INDEX seq_region_idx (seq_region_id,seq_region_start,seq_region_end),
  INDEX (analysis_id),
  PRIMARY KEY (ditag_feature_id),
  CONSTRAINT ditag_feature_fk FOREIGN KEY (ditag_id) REFERENCES ditag (ditag_id),
  CONSTRAINT ditag_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT ditag_feature_fk_2 FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

DROP TABLE IF EXISTS external_synonym;

--
-- Table: external_synonym
--
CREATE TABLE external_synonym (
  xref_id integer unsigned NOT NULL,
  synonym VARCHAR(100) NOT NULL,
  INDEX name_index (synonym),
  INDEX (xref_id),
  PRIMARY KEY (xref_id, synonym),
  CONSTRAINT external_synonym_fk FOREIGN KEY (xref_id) REFERENCES xref (xref_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS protein_align_feature;

--
-- Table: protein_align_feature
--
CREATE TABLE protein_align_feature (
  protein_align_feature_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL DEFAULT 1,
  hit_start integer NOT NULL,
  hit_end integer NOT NULL,
  hit_name VARCHAR(40) NOT NULL,
  analysis_id integer unsigned NOT NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  perc_ident FLOAT NULL,
  cigar_line text NULL,
  external_db_id integer unsigned NULL,
  hcoverage DOUBLE NULL,
  INDEX seq_region_idx (seq_region_id,analysis_id,seq_region_start,score),
  INDEX seq_region_idx_2 (seq_region_id,seq_region_start),
  INDEX hit_idx (hit_name),
  INDEX analysis_idx (analysis_id),
  INDEX external_db_idx (external_db_id),
  PRIMARY KEY (protein_align_feature_id),
  CONSTRAINT protein_align_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT protein_align_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT protein_align_feature_fk_2 FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS splicing_event_feature;

--
-- Table: splicing_event_feature
--
CREATE TABLE splicing_event_feature (
  splicing_event_feature_id integer unsigned NOT NULL,
  splicing_event_id integer unsigned NOT NULL,
  exon_id integer unsigned NOT NULL,
  transcript_id integer unsigned NOT NULL,
  feature_order integer unsigned NOT NULL,
  transcript_association integer unsigned NOT NULL,
  type ENUM('constitutive_exon', 'exon', 'flanking_exon') NULL,
  start integer unsigned NOT NULL,
  end integer unsigned NOT NULL,
  INDEX se_idx (splicing_event_id),
  INDEX transcript_idx (transcript_id),
  INDEX (exon_id),
  PRIMARY KEY (splicing_event_feature_id, exon_id, transcript_id),
  CONSTRAINT splicing_event_feature_fk FOREIGN KEY (splicing_event_id) REFERENCES splicing_event (splicing_event_id),
  CONSTRAINT splicing_event_feature_fk_1 FOREIGN KEY (exon_id) REFERENCES exon (exon_id),
  CONSTRAINT splicing_event_feature_fk_2 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS splicing_transcript_pair;

--
-- Table: splicing_transcript_pair
--
CREATE TABLE splicing_transcript_pair (
  splicing_transcript_pair_id integer unsigned NOT NULL,
  splicing_event_id integer unsigned NOT NULL,
  transcript_id_1 integer unsigned NOT NULL,
  transcript_id_2 integer unsigned NOT NULL,
  INDEX se_idx (splicing_event_id),
  INDEX (transcript_id_1),
  INDEX (transcript_id_2),
  PRIMARY KEY (splicing_transcript_pair_id),
  CONSTRAINT splicing_transcript_pair_fk FOREIGN KEY (splicing_event_id) REFERENCES splicing_event (splicing_event_id),
  CONSTRAINT splicing_transcript_pair_fk_1 FOREIGN KEY (transcript_id_1) REFERENCES transcript (transcript_id),
  CONSTRAINT splicing_transcript_pair_fk_2 FOREIGN KEY (transcript_id_2) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS transcript_supporting_feature;

--
-- Table: transcript_supporting_feature
--
CREATE TABLE transcript_supporting_feature (
  transcript_supporting_feature_id integer unsigned NOT NULL auto_increment,
  transcript_id integer unsigned NOT NULL DEFAULT 0,
  feature_type ENUM('dna_align_feature', 'protein_align_feature') NULL,
  feature_id integer unsigned NOT NULL DEFAULT 0,
  INDEX feature_idx (feature_type,feature_id),
  INDEX (transcript_id),
  PRIMARY KEY (transcript_supporting_feature_id),
  UNIQUE all_idx (transcript_id, feature_type, feature_id),
  CONSTRAINT transcript_supporting_feature_fk FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS unconventional_transcript_association;

--
-- Table: unconventional_transcript_association
--
CREATE TABLE unconventional_transcript_association (
  unconventional_transcript_association_id integer unsigned NOT NULL auto_increment,
  transcript_id integer unsigned NOT NULL,
  gene_id integer unsigned NOT NULL,
  interaction_type ENUM('antisense', 'sense_intronic', 'sense_overlaping_exonic', 'chimeric_sense_exonic') NULL,
  INDEX transcript_idx (transcript_id),
  INDEX gene_idx (gene_id),
  PRIMARY KEY (unconventional_transcript_association_id),
  CONSTRAINT unconventional_transcript_association_fk FOREIGN KEY (gene_id) REFERENCES gene (gene_id),
  CONSTRAINT unconventional_transcript_association_fk_1 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

DROP TABLE IF EXISTS transcript_attrib;

--
-- Table: transcript_attrib
--
CREATE TABLE transcript_attrib (
  transcript_attrib_id integer unsigned NOT NULL auto_increment,
  transcript_id integer unsigned NOT NULL DEFAULT 0,
  attrib_type_id integer unsigned NOT NULL DEFAULT 0,
  value text NOT NULL,
  INDEX type_val_idx (attrib_type_id,value(40)),
  INDEX val_only_idx (value(40)),
  INDEX transcript_idx (transcript_id),
  PRIMARY KEY (transcript_attrib_id),
  CONSTRAINT transcript_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT transcript_attrib_fk_1 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS gene_attrib;

--
-- Table: gene_attrib
--
CREATE TABLE gene_attrib (
  gene_attrib_id integer unsigned NOT NULL auto_increment,
  gene_id integer unsigned NOT NULL DEFAULT 0,
  attrib_type_id integer unsigned NOT NULL DEFAULT 0,
  value text NOT NULL,
  INDEX type_val_idx (attrib_type_id,value(40)),
  INDEX val_only_idx (value(40)),
  INDEX gene_idx (gene_id),
  PRIMARY KEY (gene_attrib_id),
  CONSTRAINT gene_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT gene_attrib_fk_1 FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS splicing_event;

--
-- Table: splicing_event
--
CREATE TABLE splicing_event (
  splicing_event_id integer unsigned NOT NULL auto_increment,
  name VARCHAR(134) NULL,
  gene_id integer unsigned NOT NULL,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  attrib_type_id integer unsigned NOT NULL DEFAULT 0,
  INDEX gene_idx (gene_id),
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  PRIMARY KEY (splicing_event_id),
  CONSTRAINT splicing_event_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT splicing_event_fk_1 FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS alt_allele;

--
-- Table: alt_allele
--
CREATE TABLE alt_allele (
  alt_allele_id integer unsigned NOT NULL auto_increment,
  gene_id integer unsigned NOT NULL,
  is_ref enum('0','1') NOT NULL DEFAULT '0',
  INDEX (gene_id),
  PRIMARY KEY (alt_allele_id),
  UNIQUE gene_idx (gene_id),
  UNIQUE allele_idx (alt_allele_id, gene_id),
  CONSTRAINT alt_allele_fk FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS operon_transcript_gene;

--
-- Table: operon_transcript_gene
--
CREATE TABLE operon_transcript_gene (
  operon_transcript_gene_id integer unsigned NOT NULL auto_increment,
  operon_transcript_id integer unsigned NULL,
  gene_id integer unsigned NULL,
  INDEX operon_transcript_gene_idx (operon_transcript_id,gene_id),
  PRIMARY KEY (operon_transcript_gene_id),
  CONSTRAINT operon_transcript_gene_fk FOREIGN KEY (operon_transcript_id) REFERENCES operon_transcript (operon_transcript_id),
  CONSTRAINT operon_transcript_gene_fk_1 FOREIGN KEY (gene_id) REFERENCES gene (gene_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS gene;

--
-- Table: gene
--
CREATE TABLE gene (
  gene_id integer unsigned NOT NULL auto_increment,
  biotype VARCHAR(40) NOT NULL,
  analysis_id integer unsigned NOT NULL,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  display_xref_id integer unsigned NULL,
  source VARCHAR(20) NOT NULL,
  status ENUM('KNOWN', 'NOVEL', 'PUTATIVE', 'PREDICTED', 'KNOWN_BY_PROJECTION', 'UNKNOWN', 'ANNOTATED') NULL,
  description text NULL,
  is_current enum('0','1') NOT NULL DEFAULT '1',
  canonical_transcript_id integer unsigned NOT NULL,
  canonical_annotation VARCHAR(255) NULL DEFAULT NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version integer unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX xref_id_index (display_xref_id),
  INDEX analysis_idx (analysis_id),
  INDEX stable_id_idx (stable_id,version),
  INDEX canonical_transcript_id_idx (canonical_transcript_id),
  PRIMARY KEY (gene_id),
  CONSTRAINT gene_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT gene_fk_1 FOREIGN KEY (display_xref_id) REFERENCES xref (xref_id),
  CONSTRAINT gene_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT gene_fk_3 FOREIGN KEY (canonical_transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS transcript;

--
-- Table: transcript
--
CREATE TABLE transcript (
  transcript_id integer unsigned NOT NULL auto_increment,
  gene_id integer unsigned NULL,
  analysis_id integer unsigned NOT NULL,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  display_xref_id integer unsigned NULL,
  biotype VARCHAR(40) NOT NULL,
  status ENUM('KNOWN', 'NOVEL', 'PUTATIVE', 'PREDICTED', 'KNOWN_BY_PROJECTION', 'UNKNOWN', 'ANNOTATED') NULL,
  description text NULL,
  is_current enum('0','1') NOT NULL DEFAULT '1',
  canonical_translation_id integer unsigned NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version integer unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX gene_index (gene_id),
  INDEX xref_id_index (display_xref_id),
  INDEX analysis_idx (analysis_id),
  INDEX stable_id_idx (stable_id,version),
  INDEX (canonical_translation_id),
  PRIMARY KEY (transcript_id),
  UNIQUE canonical_translation_idx (canonical_translation_id),
  CONSTRAINT transcript_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT transcript_fk_1 FOREIGN KEY (display_xref_id) REFERENCES xref (xref_id),
  CONSTRAINT transcript_fk_2 FOREIGN KEY (gene_id) REFERENCES gene (gene_id),
  CONSTRAINT transcript_fk_3 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT transcript_fk_4 FOREIGN KEY (canonical_translation_id) REFERENCES translation (translation_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS translation_attrib;

--
-- Table: translation_attrib
--
CREATE TABLE translation_attrib (
  translation_attrib_id integer unsigned NOT NULL auto_increment,
  translation_id integer unsigned NOT NULL DEFAULT 0,
  attrib_type_id integer unsigned NOT NULL DEFAULT 0,
  value text NOT NULL,
  INDEX type_val_idx (attrib_type_id,value(40)),
  INDEX val_only_idx (value(40)),
  INDEX translation_idx (translation_id),
  PRIMARY KEY (translation_attrib_id),
  CONSTRAINT translation_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT translation_attrib_fk_1 FOREIGN KEY (translation_id) REFERENCES translation (translation_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS protein_feature;

--
-- Table: protein_feature
--
CREATE TABLE protein_feature (
  protein_feature_id integer unsigned NOT NULL auto_increment,
  translation_id integer unsigned NOT NULL,
  seq_start integer NOT NULL,
  seq_end integer NOT NULL,
  hit_start integer NOT NULL,
  hit_end integer NOT NULL,
  hit_name VARCHAR(40) NOT NULL,
  analysis_id integer unsigned NOT NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  perc_ident FLOAT NULL,
  external_data text NULL,
  INDEX translation_idx (translation_id),
  INDEX hitname_idx (hit_name),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (protein_feature_id),
  CONSTRAINT protein_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT protein_feature_fk_1 FOREIGN KEY (translation_id) REFERENCES translation (translation_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS translation;

--
-- Table: translation
--
CREATE TABLE translation (
  translation_id integer unsigned NOT NULL auto_increment,
  transcript_id integer unsigned NOT NULL,
  seq_start integer NOT NULL,
  start_exon_id integer unsigned NOT NULL comment 'relative to exon start',
  seq_end integer NOT NULL,
  end_exon_id integer unsigned NOT NULL comment 'relative to exon start',
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version integer unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX transcript_idx (transcript_id),
  INDEX stable_id_idx (stable_id,version),
  INDEX (end_exon_id),
  INDEX (start_exon_id),
  PRIMARY KEY (translation_id),
  CONSTRAINT translation_fk FOREIGN KEY (end_exon_id) REFERENCES exon (exon_id),
  CONSTRAINT translation_fk_1 FOREIGN KEY (start_exon_id) REFERENCES exon (exon_id),
  CONSTRAINT translation_fk_2 FOREIGN KEY (transcript_id) REFERENCES transcript (transcript_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS intron_supporting_evidence;

--
-- Table: intron_supporting_evidence
--
CREATE TABLE intron_supporting_evidence (
  intron_supporting_evidence_id integer unsigned NOT NULL auto_increment,
  previous_exon_id integer unsigned NOT NULL,
  next_exon_id integer unsigned NOT NULL,
  hit_name VARCHAR(100) NOT NULL,
  score DECIMAL(10, 3) NULL,
  score_type ENUM('NONE', 'DEPTH') NULL DEFAULT 'NONE',
  PRIMARY KEY (intron_supporting_evidence_id),
  UNIQUE (previous_exon_id, next_exon_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS misc_feature_misc_set;

--
-- Table: misc_feature_misc_set
--
CREATE TABLE misc_feature_misc_set (
  misc_feature_id integer unsigned NOT NULL DEFAULT 0,
  misc_set_id integer unsigned NOT NULL DEFAULT 0,
  INDEX reverse_idx (misc_set_id,misc_feature_id),
  PRIMARY KEY (misc_feature_id, misc_set_id),
  CONSTRAINT misc_feature_misc_set_fk FOREIGN KEY (misc_feature_id) REFERENCES misc_feature (misc_feature_id),
  CONSTRAINT misc_feature_misc_set_fk_1 FOREIGN KEY (misc_set_id) REFERENCES misc_set (misc_set_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS marker_feature;

--
-- Table: marker_feature
--
CREATE TABLE marker_feature (
  marker_feature_id integer unsigned NOT NULL auto_increment,
  marker_id integer unsigned NOT NULL,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  analysis_id integer unsigned NOT NULL,
  map_weight integer unsigned NULL,
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX analysis_idx (analysis_id),
  INDEX (marker_id),
  PRIMARY KEY (marker_feature_id),
  CONSTRAINT marker_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT marker_feature_fk_1 FOREIGN KEY (marker_id) REFERENCES marker (marker_id),
  CONSTRAINT marker_feature_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS supporting_feature;

--
-- Table: supporting_feature
--
CREATE TABLE supporting_feature (
  supporting_feature_id integer unsigned NOT NULL auto_increment,
  exon_id integer unsigned NOT NULL DEFAULT 0,
  feature_type ENUM('dna_align_feature', 'protein_align_feature') NULL,
  feature_id integer unsigned NOT NULL DEFAULT 0,
  INDEX feature_idx (feature_type,feature_id),
  INDEX (exon_id),
  PRIMARY KEY (supporting_feature_id),
  UNIQUE all_idx (exon_id, feature_type, feature_id),
  CONSTRAINT supporting_feature_fk FOREIGN KEY (exon_id) REFERENCES exon (exon_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS density_feature;

--
-- Table: density_feature
--
CREATE TABLE density_feature (
  density_feature_id integer unsigned NOT NULL auto_increment,
  density_type_id integer unsigned NOT NULL,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  density_value FLOAT NOT NULL,
  INDEX seq_region_idx (density_type_id,seq_region_id,seq_region_start),
  INDEX seq_region_id_idx (seq_region_id),
  PRIMARY KEY (density_feature_id),
  CONSTRAINT density_feature_fk FOREIGN KEY (density_type_id) REFERENCES density_type (density_type_id),
  CONSTRAINT density_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS repeat_feature;

--
-- Table: repeat_feature
--
CREATE TABLE repeat_feature (
  repeat_feature_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL DEFAULT 1,
  repeat_start integer NOT NULL,
  repeat_end integer NOT NULL,
  repeat_consensus_id integer unsigned NOT NULL,
  analysis_id integer unsigned NOT NULL,
  score DOUBLE NULL,
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX repeat_idx (repeat_consensus_id),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (repeat_feature_id),
  CONSTRAINT repeat_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT repeat_feature_fk_1 FOREIGN KEY (repeat_consensus_id) REFERENCES repeat_consensus (repeat_consensus_id),
  CONSTRAINT repeat_feature_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS repeat_consensus;

--
-- Table: repeat_consensus
--
CREATE TABLE repeat_consensus (
  repeat_consensus_id integer unsigned NOT NULL auto_increment,
  repeat_name VARCHAR(255) NOT NULL,
  repeat_class VARCHAR(100) NOT NULL,
  repeat_type VARCHAR(40) NOT NULL,
  repeat_consensus text NULL,
  INDEX name (repeat_name),
  INDEX class (repeat_class),
  INDEX consensus (repeat_consensus(10)),
  INDEX type (repeat_type),
  PRIMARY KEY (repeat_consensus_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS meta;

--
-- Table: meta
--
CREATE TABLE meta (
  meta_id integer NOT NULL auto_increment,
  species_id integer unsigned NULL DEFAULT 1,
  meta_key VARCHAR(40) NOT NULL,
  meta_value VARCHAR(255) binary NULL,
  INDEX species_value_idx (species_id,meta_value),
  PRIMARY KEY (meta_id),
  UNIQUE species_key_value_idx (species_id, meta_key, meta_value)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS qtl_feature;

--
-- Table: qtl_feature
--
CREATE TABLE qtl_feature (
  qtl_feature_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  qtl_id integer unsigned NOT NULL,
  analysis_id integer unsigned NOT NULL,
  INDEX qtl_idx (qtl_id),
  INDEX loc_idx (seq_region_id,seq_region_start),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (qtl_feature_id),
  CONSTRAINT qtl_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT qtl_feature_fk_1 FOREIGN KEY (qtl_id) REFERENCES qtl (qtl_id),
  CONSTRAINT qtl_feature_fk_2 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS qtl_synonym;

--
-- Table: qtl_synonym
--
CREATE TABLE qtl_synonym (
  qtl_synonym_id integer unsigned NOT NULL auto_increment,
  qtl_id integer unsigned NOT NULL,
  source_database ENUM('rat genome database', 'ratmap') NOT NULL,
  source_primary_id VARCHAR(255) NOT NULL,
  INDEX qtl_idx (qtl_id),
  PRIMARY KEY (qtl_synonym_id),
  CONSTRAINT qtl_synonym_fk FOREIGN KEY (qtl_id) REFERENCES qtl (qtl_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS qtl;

--
-- Table: qtl
--
CREATE TABLE qtl (
  qtl_id integer unsigned NOT NULL auto_increment,
  trait VARCHAR(255) NOT NULL,
  lod_score FLOAT NULL,
  flank_marker_id_1 integer unsigned NULL,
  flank_marker_id_2 integer unsigned NULL,
  peak_marker_id integer unsigned NULL,
  INDEX trait_idx (trait),
  INDEX (flank_marker_id_1),
  INDEX (flank_marker_id_2),
  INDEX (peak_marker_id),
  PRIMARY KEY (qtl_id),
  CONSTRAINT qtl_fk FOREIGN KEY (flank_marker_id_1) REFERENCES marker (marker_id),
  CONSTRAINT qtl_fk_1 FOREIGN KEY (flank_marker_id_2) REFERENCES marker (marker_id),
  CONSTRAINT qtl_fk_2 FOREIGN KEY (peak_marker_id) REFERENCES marker (marker_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS marker_map_location;

--
-- Table: marker_map_location
--
CREATE TABLE marker_map_location (
  marker_id integer unsigned NOT NULL,
  map_id integer unsigned NOT NULL,
  chromosome_name VARCHAR(15) NOT NULL,
  marker_synonym_id integer unsigned NOT NULL,
  position VARCHAR(15) NOT NULL,
  lod_score DOUBLE NULL,
  INDEX map_idx (map_id,chromosome_name,position),
  INDEX (marker_id),
  INDEX (marker_synonym_id),
  PRIMARY KEY (marker_id, map_id),
  CONSTRAINT marker_map_location_fk FOREIGN KEY (map_id) REFERENCES map (map_id),
  CONSTRAINT marker_map_location_fk_1 FOREIGN KEY (marker_id) REFERENCES marker (marker_id),
  CONSTRAINT marker_map_location_fk_2 FOREIGN KEY (marker_synonym_id) REFERENCES marker_synonym (marker_synonym_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS marker;

--
-- Table: marker
--
CREATE TABLE marker (
  marker_id integer unsigned NOT NULL auto_increment,
  display_marker_synonym_id integer unsigned NULL,
  left_primer VARCHAR(100) NOT NULL,
  right_primer VARCHAR(100) NOT NULL,
  min_primer_dist integer unsigned NOT NULL,
  max_primer_dist integer unsigned NOT NULL,
  priority integer NULL,
  type ENUM('est', 'microsatellite') NULL,
  INDEX marker_idx (marker_id,priority),
  INDEX display_idx (display_marker_synonym_id),
  PRIMARY KEY (marker_id),
  CONSTRAINT marker_fk FOREIGN KEY (display_marker_synonym_id) REFERENCES marker_synonym (marker_synonym_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS marker_synonym;

--
-- Table: marker_synonym
--
CREATE TABLE marker_synonym (
  marker_synonym_id integer unsigned NOT NULL auto_increment,
  marker_id integer unsigned NOT NULL,
  source VARCHAR(20) NULL,
  name VARCHAR(50) NULL,
  INDEX marker_synonym_idx (marker_synonym_id,name),
  INDEX marker_idx (marker_id),
  PRIMARY KEY (marker_synonym_id),
  CONSTRAINT marker_synonym_fk FOREIGN KEY (marker_id) REFERENCES marker (marker_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS dna;

--
-- Table: dna
--
CREATE TABLE dna (
  seq_region_id integer unsigned NOT NULL,
  sequence LONGTEXT NOT NULL,
  INDEX (seq_region_id),
  PRIMARY KEY (seq_region_id),
  CONSTRAINT dna_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB MAX_ROWS=750000 AVG_ROW_LENGTH=19000 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS misc_attrib;

--
-- Table: misc_attrib
--
CREATE TABLE misc_attrib (
  misc_attrib_id integer unsigned NOT NULL auto_increment,
  misc_feature_id integer unsigned NOT NULL DEFAULT 0,
  attrib_type_id integer unsigned NOT NULL DEFAULT 0,
  value text NOT NULL,
  INDEX type_val_idx (attrib_type_id,value(40)),
  INDEX val_only_idx (value(40)),
  INDEX misc_feature_idx (misc_feature_id),
  PRIMARY KEY (misc_attrib_id),
  CONSTRAINT misc_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT misc_attrib_fk_1 FOREIGN KEY (misc_feature_id) REFERENCES misc_feature (misc_feature_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS seq_region_attrib;

--
-- Table: seq_region_attrib
--
CREATE TABLE seq_region_attrib (
  seq_region_attrib_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL DEFAULT 0,
  attrib_type_id integer unsigned NOT NULL DEFAULT 0,
  value text NOT NULL,
  INDEX type_val_idx (attrib_type_id,value(40)),
  INDEX val_only_idx (value(40)),
  INDEX seq_region_idx (seq_region_id),
  PRIMARY KEY (seq_region_attrib_id),
  CONSTRAINT seq_region_attrib_fk FOREIGN KEY (attrib_type_id) REFERENCES attrib_type (attrib_type_id),
  CONSTRAINT seq_region_attrib_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS stable_id_event;

--
-- Table: stable_id_event
--
CREATE TABLE stable_id_event (
  stable_id_event_id integer unsigned NOT NULL auto_increment,
  old_stable_id VARCHAR(128) NULL,
  old_version integer NULL,
  new_stable_id VARCHAR(128) NULL,
  new_version integer NULL,
  mapping_session_id integer unsigned NOT NULL DEFAULT 0,
  type ENUM('gene', 'transcript', 'translation') NOT NULL,
  score FLOAT NOT NULL DEFAULT 0,
  INDEX new_idx (new_stable_id),
  INDEX old_idx (old_stable_id),
  INDEX (mapping_session_id),
  PRIMARY KEY (stable_id_event_id),
  UNIQUE uni_idx (mapping_session_id, old_stable_id, new_stable_id, type),
  CONSTRAINT stable_id_event_fk FOREIGN KEY (mapping_session_id) REFERENCES mapping_session (mapping_session_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS gene_archive;

--
-- Table: gene_archive
--
CREATE TABLE gene_archive (
  gene_archive_id integer unsigned NOT NULL auto_increment,
  gene_stable_id VARCHAR(128) NOT NULL,
  gene_version integer NOT NULL DEFAULT 1,
  transcript_stable_id VARCHAR(128) NOT NULL,
  transcript_version integer NOT NULL DEFAULT 1,
  translation_stable_id VARCHAR(128) NULL,
  translation_version integer NOT NULL DEFAULT 1,
  peptide_archive_id integer unsigned NULL,
  mapping_session_id integer unsigned NOT NULL,
  INDEX gene_idx (gene_stable_id,gene_version),
  INDEX transcript_idx (transcript_stable_id,transcript_version),
  INDEX translation_idx (translation_stable_id,translation_version),
  INDEX peptide_archive_id_idx (peptide_archive_id),
  INDEX (mapping_session_id),
  PRIMARY KEY (gene_archive_id),
  CONSTRAINT gene_archive_fk FOREIGN KEY (mapping_session_id) REFERENCES mapping_session (mapping_session_id),
  CONSTRAINT gene_archive_fk_1 FOREIGN KEY (peptide_archive_id) REFERENCES peptide_archive (peptide_archive_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS peptide_archive;

--
-- Table: peptide_archive
--
CREATE TABLE peptide_archive (
  peptide_archive_id integer unsigned NOT NULL auto_increment,
  md5_checksum VARCHAR(32) NULL,
  peptide_seq MEDIUMTEXT NOT NULL,
  INDEX checksum (md5_checksum),
  PRIMARY KEY (peptide_archive_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS misc_feature;

--
-- Table: misc_feature
--
CREATE TABLE misc_feature (
  misc_feature_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL DEFAULT 0,
  seq_region_start integer unsigned NOT NULL DEFAULT 0,
  seq_region_end integer unsigned NOT NULL DEFAULT 0,
  seq_region_strand TINYINT(4) NOT NULL DEFAULT 0,
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  PRIMARY KEY (misc_feature_id),
  CONSTRAINT misc_feature_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS prediction_exon;

--
-- Table: prediction_exon
--
CREATE TABLE prediction_exon (
  prediction_exon_id integer unsigned NOT NULL auto_increment,
  prediction_transcript_id integer unsigned NOT NULL,
  exon_rank integer unsigned NOT NULL,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  start_phase TINYINT(4) NOT NULL,
  score DOUBLE NULL,
  p_value DOUBLE NULL,
  INDEX transcript_idx (prediction_transcript_id),
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  PRIMARY KEY (prediction_exon_id),
  CONSTRAINT prediction_exon_fk FOREIGN KEY (prediction_transcript_id) REFERENCES prediction_transcript (prediction_transcript_id),
  CONSTRAINT prediction_exon_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS prediction_transcript;

--
-- Table: prediction_transcript
--
CREATE TABLE prediction_transcript (
  prediction_transcript_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  analysis_id integer unsigned NOT NULL,
  display_label VARCHAR(255) NULL,
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX analysis_idx (analysis_id),
  PRIMARY KEY (prediction_transcript_id),
  CONSTRAINT prediction_transcript_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT prediction_transcript_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS dnac;

--
-- Table: dnac
--
CREATE TABLE dnac (
  seq_region_id integer unsigned NOT NULL,
  sequence MEDIUMBLOB NOT NULL,
  n_line text NULL,
  INDEX (seq_region_id),
  PRIMARY KEY (seq_region_id),
  CONSTRAINT dnac_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB MAX_ROWS=750000 AVG_ROW_LENGTH=19000 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS assembly;

--
-- Table: assembly
--
CREATE TABLE assembly (
  assembly_id integer unsigned NOT NULL auto_increment,
  asm_seq_region_id integer unsigned NOT NULL,
  cmp_seq_region_id integer unsigned NOT NULL,
  asm_start integer NOT NULL,
  asm_end integer NOT NULL,
  cmp_start integer NOT NULL,
  cmp_end integer NOT NULL,
  ori TINYINT(4) NOT NULL,
  INDEX cmp_seq_region_idx (cmp_seq_region_id),
  INDEX asm_seq_region_idx (asm_seq_region_id,asm_start),
  PRIMARY KEY (assembly_id),
  UNIQUE all_idx (asm_seq_region_id, cmp_seq_region_id, asm_start, asm_end, cmp_start, cmp_end, ori),
  CONSTRAINT assembly_fk FOREIGN KEY (asm_seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT assembly_fk_1 FOREIGN KEY (cmp_seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS exon;

--
-- Table: exon
--
CREATE TABLE exon (
  exon_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  phase TINYINT(4) NOT NULL,
  end_phase TINYINT(4) NOT NULL,
  is_current enum('0','1') NOT NULL DEFAULT '1',
  is_constitutive enum('0','1') NOT NULL DEFAULT '0',
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version integer unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX stable_id_idx (stable_id,version),
  PRIMARY KEY (exon_id),
  CONSTRAINT exon_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS operon_transcript;

--
-- Table: operon_transcript
--
CREATE TABLE operon_transcript (
  operon_transcript_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  operon_id integer unsigned NOT NULL,
  display_label VARCHAR(255) NULL DEFAULT NULL,
  analysis_id integer unsigned NOT NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version integer unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX operon_idx (operon_id),
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX stable_id_idx (stable_id,version),
  INDEX (analysis_id),
  PRIMARY KEY (operon_transcript_id),
  CONSTRAINT operon_transcript_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT operon_transcript_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT operon_transcript_fk_2 FOREIGN KEY (operon_id) REFERENCES operon (operon_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS operon;

--
-- Table: operon
--
CREATE TABLE operon (
  operon_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  display_label VARCHAR(255) NULL DEFAULT NULL,
  analysis_id integer unsigned NOT NULL,
  stable_id VARCHAR(128) NULL DEFAULT NULL,
  version integer unsigned NOT NULL DEFAULT 1,
  created_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  modified_date datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX name_idx (display_label),
  INDEX stable_id_idx (stable_id,version),
  INDEX (analysis_id),
  PRIMARY KEY (operon_id),
  CONSTRAINT operon_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT operon_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS simple_feature;

--
-- Table: simple_feature
--
CREATE TABLE simple_feature (
  simple_feature_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  display_label VARCHAR(255) NOT NULL,
  analysis_id integer unsigned NOT NULL,
  score DOUBLE NULL,
  INDEX seq_region_idx (seq_region_id,seq_region_start),
  INDEX analysis_idx (analysis_id),
  INDEX hit_idx (display_label),
  PRIMARY KEY (simple_feature_id),
  CONSTRAINT simple_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT simple_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

DROP TABLE IF EXISTS dna_align_feature;

--
-- Table: dna_align_feature
--
CREATE TABLE dna_align_feature (
  dna_align_feature_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  seq_region_strand TINYINT(4) NOT NULL,
  hit_start integer NOT NULL,
  hit_end integer NOT NULL,
  hit_strand TINYINT(4) NOT NULL,
  hit_name VARCHAR(40) NOT NULL,
  analysis_id integer unsigned NOT NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  perc_ident FLOAT NULL,
  cigar_line text NULL,
  external_db_id integer unsigned NULL,
  hcoverage DOUBLE NULL,
  external_data text NULL,
  pair_dna_align_feature_id integer unsigned NULL,
  INDEX seq_region_idx (seq_region_id,analysis_id,seq_region_start,score),
  INDEX seq_region_idx_2 (seq_region_id,seq_region_start),
  INDEX hit_idx (hit_name),
  INDEX analysis_idx (analysis_id),
  INDEX external_db_idx (external_db_id),
  INDEX pair_idx (pair_dna_align_feature_id),
  PRIMARY KEY (dna_align_feature_id),
  CONSTRAINT dna_align_feature_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT dna_align_feature_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT dna_align_feature_fk_2 FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id),
  CONSTRAINT dna_align_feature_fk_3 FOREIGN KEY (pair_dna_align_feature_id) REFERENCES dna_align_feature (dna_align_feature_id)
) ENGINE=InnoDB MAX_ROWS=100000000 AVG_ROW_LENGTH=80 COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS seq_region_mapping;

--
-- Table: seq_region_mapping
--
CREATE TABLE seq_region_mapping (
  seq_region_mapping_id integer unsigned NOT NULL auto_increment,
  external_seq_region_id integer unsigned NOT NULL,
  internal_seq_region_id integer unsigned NOT NULL,
  mapping_set_id integer unsigned NOT NULL,
  INDEX mapping_set_idx (mapping_set_id),
  INDEX (internal_seq_region_id),
  PRIMARY KEY (seq_region_mapping_id),
  CONSTRAINT seq_region_mapping_fk FOREIGN KEY (internal_seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT seq_region_mapping_fk_1 FOREIGN KEY (mapping_set_id) REFERENCES mapping_set (mapping_set_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

DROP TABLE IF EXISTS assembly_exception;

--
-- Table: assembly_exception
--
CREATE TABLE assembly_exception (
  assembly_exception_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  exc_type ENUM('HAP', 'PAR', 'PATCH_FIX', 'PATCH_NOVEL') NOT NULL,
  exc_seq_region_id integer unsigned NOT NULL,
  exc_seq_region_start integer unsigned NOT NULL,
  exc_seq_region_end integer unsigned NOT NULL,
  ori integer NOT NULL,
  INDEX sr_idx (seq_region_id,seq_region_start),
  INDEX ex_idx (exc_seq_region_id,exc_seq_region_start),
  PRIMARY KEY (assembly_exception_id),
  CONSTRAINT assembly_exception_fk FOREIGN KEY (exc_seq_region_id) REFERENCES seq_region (seq_region_id),
  CONSTRAINT assembly_exception_fk_1 FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS karyotype;

--
-- Table: karyotype
--
CREATE TABLE karyotype (
  karyotype_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  seq_region_start integer unsigned NOT NULL,
  seq_region_end integer unsigned NOT NULL,
  band VARCHAR(40) NOT NULL,
  stain VARCHAR(40) NOT NULL,
  INDEX region_band_idx (seq_region_id,band),
  PRIMARY KEY (karyotype_id),
  CONSTRAINT karyotype_fk FOREIGN KEY (seq_region_id) REFERENCES seq_region (seq_region_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS seq_region;

--
-- Table: seq_region
--
CREATE TABLE seq_region (
  seq_region_id integer unsigned NOT NULL auto_increment,
  name VARCHAR(40) NOT NULL,
  coord_system_id integer unsigned NOT NULL,
  length integer unsigned NOT NULL,
  INDEX cs_idx (coord_system_id),
  PRIMARY KEY (seq_region_id),
  UNIQUE name_cs_idx (name, coord_system_id),
  CONSTRAINT seq_region_fk FOREIGN KEY (coord_system_id) REFERENCES coord_system (coord_system_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS meta_coord;

--
-- Table: meta_coord
--
CREATE TABLE meta_coord (
  meta_coord_id integer unsigned NOT NULL auto_increment,
  table_name VARCHAR(40) NOT NULL,
  coord_system_id integer unsigned NOT NULL,
  max_length integer NULL,
  INDEX (coord_system_id),
  PRIMARY KEY (meta_coord_id),
  UNIQUE cs_table_name_idx (coord_system_id, table_name),
  CONSTRAINT meta_coord_fk FOREIGN KEY (coord_system_id) REFERENCES coord_system (coord_system_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS data_file;

--
-- Table: data_file
--
CREATE TABLE data_file (
  data_file_id integer unsigned NOT NULL auto_increment,
  coord_system_id integer unsigned NOT NULL,
  analysis_id integer unsigned NOT NULL,
  name varchar(100) NOT NULL,
  version_lock TINYINT(4) NOT NULL DEFAULT 0,
  absolute TINYINT(4) NOT NULL DEFAULT 0,
  url text NULL,
  file_type enum('BAM', 'BIGBED', 'BIGWIG', 'VCF') NULL,
  INDEX df_name_idx (name),
  INDEX df_analysis_idx (analysis_id),
  INDEX (coord_system_id),
  PRIMARY KEY (data_file_id),
  UNIQUE df_unq_idx (coord_system_id, analysis_id, name, file_type),
  CONSTRAINT data_file_fk FOREIGN KEY (coord_system_id) REFERENCES coord_system (coord_system_id),
  CONSTRAINT data_file_fk_1 FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS coord_system;

--
-- Table: coord_system
--
CREATE TABLE coord_system (
  coord_system_id integer unsigned NOT NULL auto_increment,
  species_id integer unsigned NOT NULL DEFAULT 1,
  name VARCHAR(40) NOT NULL,
  version VARCHAR(255) NULL DEFAULT NULL,
  rank integer NOT NULL,
  attrib SET('default_version', 'sequence_level') NULL,
  INDEX species_idx (species_id),
  PRIMARY KEY (coord_system_id),
  UNIQUE rank_idx (rank, species_id),
  UNIQUE name_idx (name, version, species_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS mapping_set;

--
-- Table: mapping_set
--
CREATE TABLE mapping_set (
  mapping_set_id integer unsigned NOT NULL,
  schema_build VARCHAR(20) NOT NULL,
  PRIMARY KEY (mapping_set_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

DROP TABLE IF EXISTS unmapped_object;

--
-- Table: unmapped_object
--
CREATE TABLE unmapped_object (
  unmapped_object_id integer unsigned NOT NULL auto_increment,
  type ENUM('xref', 'cDNA', 'Marker') NOT NULL,
  analysis_id integer unsigned NOT NULL,
  external_db_id integer unsigned NULL,
  identifier VARCHAR(255) NOT NULL,
  unmapped_reason_id integer unsigned NOT NULL,
  query_score DOUBLE NULL,
  target_score DOUBLE NULL,
  ensembl_id integer unsigned NULL DEFAULT 0,
  ensembl_object_type ENUM('RawContig', 'Transcript', 'Gene', 'Translation') NULL DEFAULT 'RawContig',
  parent VARCHAR(255) NULL DEFAULT NULL,
  INDEX id_idx (identifier(50)),
  INDEX anal_exdb_idx (analysis_id,external_db_id),
  INDEX ext_db_identifier_idx (external_db_id,identifier),
  INDEX (unmapped_reason_id),
  PRIMARY KEY (unmapped_object_id),
  UNIQUE unique_unmapped_obj_idx (ensembl_id, ensembl_object_type, identifier, unmapped_reason_id, parent, external_db_id),
  CONSTRAINT unmapped_object_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id),
  CONSTRAINT unmapped_object_fk_1 FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id),
  CONSTRAINT unmapped_object_fk_2 FOREIGN KEY (unmapped_reason_id) REFERENCES unmapped_reason (unmapped_reason_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS dependent_xref;

--
-- Table: dependent_xref
--
CREATE TABLE dependent_xref (
  object_xref_id integer unsigned NOT NULL,
  master_xref_id integer unsigned NOT NULL,
  dependent_xref_id integer unsigned NOT NULL,
  INDEX dependent (dependent_xref_id),
  INDEX master_idx (master_xref_id),
  INDEX (object_xref_id),
  PRIMARY KEY (object_xref_id),
  CONSTRAINT dependent_xref_fk FOREIGN KEY (object_xref_id) REFERENCES object_xref (object_xref_id),
  CONSTRAINT dependent_xref_fk_1 FOREIGN KEY (master_xref_id) REFERENCES xref (xref_id),
  CONSTRAINT dependent_xref_fk_2 FOREIGN KEY (dependent_xref_id) REFERENCES xref (xref_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS ontology_xref;

--
-- Table: ontology_xref
--
CREATE TABLE ontology_xref (
  ontology_xref_id integer unsigned NOT NULL auto_increment,
  object_xref_id integer unsigned NOT NULL DEFAULT 0,
  source_xref_id integer unsigned NULL DEFAULT NULL,
  linkage_type VARCHAR(3) NULL DEFAULT NULL,
  INDEX source_idx (source_xref_id),
  INDEX object_idx (object_xref_id),
  PRIMARY KEY (ontology_xref_id),
  UNIQUE object_source_type_idx (object_xref_id, source_xref_id, linkage_type),
  CONSTRAINT ontology_xref_fk FOREIGN KEY (object_xref_id) REFERENCES object_xref (object_xref_id),
  CONSTRAINT ontology_xref_fk_1 FOREIGN KEY (source_xref_id) REFERENCES xref (xref_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS identity_xref;

--
-- Table: identity_xref
--
CREATE TABLE identity_xref (
  object_xref_id integer unsigned NOT NULL,
  xref_identity integer NULL,
  ensembl_identity integer NULL,
  xref_start integer NULL,
  xref_end integer NULL,
  ensembl_start integer NULL,
  ensembl_end integer NULL,
  cigar_line text NULL,
  score DOUBLE NULL,
  evalue DOUBLE NULL,
  INDEX (object_xref_id),
  PRIMARY KEY (object_xref_id),
  CONSTRAINT identity_xref_fk FOREIGN KEY (object_xref_id) REFERENCES object_xref (object_xref_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS object_xref;

--
-- Table: object_xref
--
CREATE TABLE object_xref (
  object_xref_id integer unsigned NOT NULL auto_increment,
  ensembl_id integer unsigned NOT NULL,
  ensembl_object_type ENUM('RawContig', 'Transcript', 'Gene', 'Translation', 'Operon', 'OperonTranscript') NOT NULL,
  xref_id integer unsigned NOT NULL,
  linkage_annotation VARCHAR(255) NULL DEFAULT NULL,
  analysis_id integer unsigned NULL DEFAULT NULL,
  INDEX ensembl_idx (ensembl_object_type,ensembl_id),
  INDEX analysis_idx (analysis_id),
  INDEX (xref_id),
  PRIMARY KEY (object_xref_id),
  UNIQUE xref_idx (xref_id, ensembl_object_type, ensembl_id, analysis_id),
  CONSTRAINT object_xref_fk FOREIGN KEY (xref_id) REFERENCES xref (xref_id),
  CONSTRAINT object_xref_fk_1 FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS xref;

--
-- Table: xref
--
CREATE TABLE xref (
  xref_id integer unsigned NOT NULL auto_increment,
  external_db_id integer unsigned NOT NULL,
  dbprimary_acc VARCHAR(40) NOT NULL,
  display_label VARCHAR(128) NOT NULL,
  version VARCHAR(10) NOT NULL DEFAULT '0',
  description text NULL,
  info_type ENUM('PROJECTION', 'MISC', 'DEPENDENT', 'DIRECT', 'SEQUENCE_MATCH', 'INFERRED_PAIR', 'PROBE', 'UNMAPPED', 'COORDINATE_OVERLAP', 'CHECKSUM') NULL,
  info_text VARCHAR(255) NULL,
  INDEX display_index (display_label),
  INDEX info_type_idx (info_type),
  INDEX (external_db_id),
  PRIMARY KEY (xref_id),
  UNIQUE id_index (dbprimary_acc, external_db_id, info_type, info_text),
  CONSTRAINT xref_fk FOREIGN KEY (external_db_id) REFERENCES external_db (external_db_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS external_db;

--
-- Table: external_db
--
CREATE TABLE external_db (
  external_db_id integer unsigned NOT NULL auto_increment,
  db_name VARCHAR(100) NOT NULL,
  db_release VARCHAR(255) NULL,
  status ENUM('KNOWNXREF', 'KNOWN', 'XREF', 'PRED', 'ORTH', 'PSEUDO') NOT NULL,
  priority integer NOT NULL,
  db_display_name VARCHAR(255) NULL,
  type ENUM('ARRAY', 'ALT_TRANS', 'ALT_GENE', 'MISC', 'LIT', 'PRIMARY_DB_SYNONYM', 'ENSEMBL') NULL,
  secondary_db_name VARCHAR(255) NULL DEFAULT NULL,
  secondary_db_table VARCHAR(255) NULL DEFAULT NULL,
  description text NULL,
  PRIMARY KEY (external_db_id),
  UNIQUE db_name_db_release_idx (db_name, db_release)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS density_type;

--
-- Table: density_type
--
CREATE TABLE density_type (
  density_type_id integer unsigned NOT NULL auto_increment,
  analysis_id integer unsigned NOT NULL,
  block_size integer NOT NULL,
  region_features integer NOT NULL,
  value_type ENUM('sum', 'ratio') NOT NULL,
  INDEX (analysis_id),
  PRIMARY KEY (density_type_id),
  UNIQUE analysis_idx (analysis_id, block_size, region_features),
  CONSTRAINT density_type_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS analysis_description;

--
-- Table: analysis_description
--
CREATE TABLE analysis_description (
  analysis_description integer unsigned NOT NULL auto_increment,
  analysis_id integer unsigned NOT NULL,
  description text NULL,
  display_label VARCHAR(255) NOT NULL,
  displayable enum('0','1') NOT NULL DEFAULT '1',
  web_data text NULL,
  INDEX (analysis_id),
  PRIMARY KEY (analysis_description),
  UNIQUE analysis_idx (analysis_id),
  CONSTRAINT analysis_description_fk FOREIGN KEY (analysis_id) REFERENCES analysis (analysis_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS analysis;

--
-- Table: analysis
--
CREATE TABLE analysis (
  analysis_id integer unsigned NOT NULL auto_increment,
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
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS seq_region_synonym;

--
-- Table: seq_region_synonym
--
CREATE TABLE seq_region_synonym (
  seq_region_synonym_id integer unsigned NOT NULL auto_increment,
  seq_region_id integer unsigned NOT NULL,
  synonym VARCHAR(40) NOT NULL,
  external_db_id integer unsigned NULL,
  INDEX seq_region_idx (seq_region_id),
  PRIMARY KEY (seq_region_synonym_id),
  UNIQUE syn_idx (synonym)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS misc_set;

--
-- Table: misc_set
--
CREATE TABLE misc_set (
  misc_set_id integer unsigned NOT NULL auto_increment,
  code VARCHAR(25) NOT NULL DEFAULT '',
  name VARCHAR(255) NOT NULL DEFAULT '',
  description text NOT NULL,
  max_length integer unsigned NOT NULL,
  PRIMARY KEY (misc_set_id),
  UNIQUE code_idx (code)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS attrib_type;

--
-- Table: attrib_type
--
CREATE TABLE attrib_type (
  attrib_type_id integer unsigned NOT NULL auto_increment,
  code VARCHAR(15) NOT NULL DEFAULT '',
  name VARCHAR(255) NOT NULL DEFAULT '',
  description text NULL,
  PRIMARY KEY (attrib_type_id),
  UNIQUE code_idx (code)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS mapping_session;

--
-- Table: mapping_session
--
CREATE TABLE mapping_session (
  mapping_session_id integer unsigned NOT NULL auto_increment,
  old_db_name VARCHAR(80) NOT NULL DEFAULT '',
  new_db_name VARCHAR(80) NOT NULL DEFAULT '',
  old_release VARCHAR(5) NOT NULL DEFAULT '',
  new_release VARCHAR(5) NOT NULL DEFAULT '',
  old_assembly VARCHAR(20) NOT NULL DEFAULT '',
  new_assembly VARCHAR(20) NOT NULL DEFAULT '',
  created datetime NOT NULL,
  PRIMARY KEY (mapping_session_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS map;

--
-- Table: map
--
CREATE TABLE map (
  map_id integer unsigned NOT NULL auto_increment,
  map_name VARCHAR(30) NOT NULL,
  PRIMARY KEY (map_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS interpro;

--
-- Table: interpro
--
CREATE TABLE interpro (
  interpro_id integer unsigned NOT NULL auto_increment,
  interpro_ac VARCHAR(40) NOT NULL,
  id VARCHAR(40) NOT NULL,
  INDEX id_idx (id),
  PRIMARY KEY (interpro_id),
  UNIQUE accession_idx (interpro_ac, id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

DROP TABLE IF EXISTS ditag;

--
-- Table: ditag
--
CREATE TABLE ditag (
  ditag_id integer unsigned NOT NULL auto_increment,
  name VARCHAR(30) NOT NULL,
  type VARCHAR(30) NOT NULL,
  tag_count integer unsigned NOT NULL DEFAULT 1,
  sequence TINYTEXT NOT NULL,
  PRIMARY KEY (ditag_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET latin1;

DROP TABLE IF EXISTS unmapped_reason;

--
-- Table: unmapped_reason
--
CREATE TABLE unmapped_reason (
  unmapped_reason_id integer unsigned NOT NULL auto_increment,
  summary_description VARCHAR(255) NULL,
  full_description VARCHAR(255) NULL,
  PRIMARY KEY (unmapped_reason_id)
) ENGINE=InnoDB COLLATE latin1_swedish_ci;

SET foreign_key_checks=1;
