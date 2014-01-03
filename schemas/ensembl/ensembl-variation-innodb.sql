SET storage_engine=InnoDB;


CREATE table variation (
  variation_id int(10) unsigned not null auto_increment, # PK
  source_id int(10) unsigned not null, 
  name varchar(255),
  validation_status SET('cluster','freq',
								 'submitter','doublehit',
								 'hapmap','1000Genome',
								 'failed','precious'),
  ancestral_allele varchar(255) DEFAULT NULL,
  flipped tinyint(1) unsigned NULL DEFAULT NULL,
  class_attrib_id int(10) unsigned default 0,
  somatic tinyint(1) DEFAULT 0 NOT NULL,
  minor_allele varchar(50) DEFAULT NULL,
  minor_allele_freq float DEFAULT NULL,
  minor_allele_count int(10) unsigned DEFAULT NULL,
  clinical_significance SET('drug-response','histocompatibility','non-pathogenic','other','pathogenic','probable-non-pathogenic','probable-pathogenic','unknown','untested'),
  evidence SET('Multiple_observations','Frequency','HapMap','1000Genomes','Cited','ESP'),
	primary key( variation_id ),
	unique ( name ),
	key source_idx (source_id)
);


CREATE table variation_feature(
	variation_feature_id int(10) unsigned not null auto_increment,
	seq_region_id int(10) unsigned not null,
	seq_region_start int not null,
	seq_region_end int not null,
	seq_region_strand tinyint not null,
	variation_id int(10) unsigned not null,
	allele_string varchar(50000),
    variation_name varchar(255),
	map_weight int not null,
	flags SET('genotyped'),
	source_id int(10) unsigned not null, 
	validation_status SET(
        'cluster',
        'freq',
		'submitter',
        'doublehit',
		'hapmap',
        '1000Genome',
		'precious'
    ),
    consequence_types SET (
        'intergenic_variant',
        'splice_acceptor_variant',
        'splice_donor_variant',
        'stop_lost',
        'coding_sequence_variant',
        'missense_variant',
        'stop_gained',
        'synonymous_variant',
        'frameshift_variant',
        'nc_transcript_variant',
        'non_coding_exon_variant',
        'mature_miRNA_variant',
        'NMD_transcript_variant',
        '5_prime_UTR_variant',
        '3_prime_UTR_variant',
        'incomplete_terminal_codon_variant',
        'intron_variant',
        'splice_region_variant',
        'downstream_gene_variant',
        'upstream_gene_variant',
        'initiator_codon_variant',
        'stop_retained_variant',
        'inframe_insertion',
        'inframe_deletion',
        'transcript_ablation',
        'transcript_fusion',
        'transcript_amplification',
        'transcript_translocation',
        'TFBS_ablation',
        'TFBS_fusion',
        'TFBS_amplification',
        'TFBS_translocation',
        'regulatory_region_ablation',
        'regulatory_region_fusion',
        'regulatory_region_amplification',
        'regulatory_region_translocation',
        'feature_elongation',
        'feature_truncation',
        'regulatory_region_variant',
        'TF_binding_site_variant'
    ) DEFAULT 'intergenic_variant' NOT NULL,
    variation_set_id SET (
            '1','2','3','4','5','6','7','8',
            '9','10','11','12','13','14','15','16',
            '17','18','19','20','21','22','23','24',
            '25','26','27','28','29','30','31','32',
            '33','34','35','36','37','38','39','40',
            '41','42','43','44','45','46','47','48',
            '49','50','51','52','53','54','55','56',
            '57','58','59','60','61','62','63','64'
    ) NOT NULL DEFAULT '',
    class_attrib_id int(10) unsigned default 0,
    somatic tinyint(1) DEFAULT 0 NOT NULL,
    minor_allele varchar(50) DEFAULT NULL,
    minor_allele_freq float DEFAULT NULL,
    minor_allele_count int(10) unsigned DEFAULT NULL,
    alignment_quality double  DEFAULT NULL,
    evidence SET('Multiple_observations','Frequency','HapMap','1000Genomes','Cited','ESP'),
    clinical_significance SET('drug-response','histocompatibility','non-pathogenic','other','pathogenic','probable-non-pathogenic','probable-pathogenic','unknown','untested') DEFAULT NULL,
   	primary key( variation_feature_id ),
	  key pos_idx( seq_region_id, seq_region_start, seq_region_end ),
	  key variation_idx( variation_id ),
    key variation_set_idx ( variation_set_id ),
    key consequence_type_idx (consequence_types)
);


CREATE table variation_synonym (
  variation_synonym_id int(10) unsigned not null auto_increment,
  variation_id int(10) unsigned not null,
  subsnp_id int(15) unsigned ,
  source_id int(10) unsigned not null,
  name varchar(255),
  moltype varchar(50),
  primary key(variation_synonym_id),
  key variation_idx (variation_id),
  key subsnp_idx(subsnp_id),
  unique (name, source_id),
  key source_idx (source_id)
);

CREATE TABLE allele (
  allele_id int(11) NOT NULL AUTO_INCREMENT,
  variation_id int(11) unsigned NOT NULL,
  subsnp_id int(11) unsigned DEFAULT NULL,
  allele_code_id int(11) unsigned NOT NULL,
  population_id int(11) unsigned DEFAULT NULL,
  frequency float unsigned DEFAULT NULL,
  count int(11) unsigned DEFAULT NULL,
  frequency_submitter_handle int(10) DEFAULT NULL,
  PRIMARY KEY (allele_id),
  KEY variation_idx (variation_id),
  KEY subsnp_idx (subsnp_id),
  KEY population_idx (population_id)
);

CREATE TABLE IF NOT EXISTS `phenotype_feature` (
  `phenotype_feature_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `phenotype_id` int(11) unsigned DEFAULT NULL,
  `source_id` int(11) unsigned DEFAULT NULL,
  `study_id` int(11) unsigned DEFAULT NULL,
  `type` enum('Gene','Variation','StructuralVariation','SupportingStructuralVariation','QTL','RegulatoryFeature') DEFAULT NULL,
  `object_id` varchar(255) DEFAULT NULL,
  `is_significant` tinyint(1) unsigned DEFAULT '1',
  `seq_region_id` int(11) unsigned DEFAULT NULL,
  `seq_region_start` int(11) unsigned DEFAULT NULL,
  `seq_region_end` int(11) unsigned DEFAULT NULL,
  `seq_region_strand` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`phenotype_feature_id`),
  KEY `phenotype_idx` (`phenotype_id`),
  KEY `object_idx` (`object_id`,`type`),
  KEY `type_idx` (`type`),
  KEY `pos_idx` (`seq_region_id`,`seq_region_start`,`seq_region_end`)
);

CREATE TABLE IF NOT EXISTS `phenotype_feature_attrib` (
  `phenotype_feature_id` int(11) unsigned NOT NULL,
  `attrib_type_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `phenotype_feature_idx` (`phenotype_feature_id`),
  KEY `type_value_idx` (`attrib_type_id`,`value`)
);

CREATE TABLE `phenotype` (
  `phenotype_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `stable_id` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`phenotype_id`),
  KEY `name_idx` (`name`),
  UNIQUE KEY `desc_idx` (`description`),
  KEY `stable_idx` (`stable_id`)
);


CREATE table subsnp_handle (
  subsnp_id int(11) unsigned not null,
  handle varchar(20),
  primary key(subsnp_id)
);


CREATE table submitter_handle (
  handle_id int(10) unsigned not null auto_increment,
  handle varchar(25),
 primary key( handle_id ),
        unique ( handle )
);

CREATE TABLE allele_code (
  allele_code_id int(11) NOT NULL AUTO_INCREMENT,
  allele varchar(60000) DEFAULT NULL,
  PRIMARY KEY (allele_code_id),
  UNIQUE KEY allele_idx (allele(1000))
);

CREATE TABLE genotype_code (
  genotype_code_id int(11) unsigned NOT NULL,
  allele_code_id int(11) unsigned NOT NULL,
  haplotype_id tinyint(2) unsigned NOT NULL,
  phased tinyint(2) unsigned DEFAULT NULL,
  KEY genotype_code_id (genotype_code_id),
  KEY allele_code_id (allele_code_id)
);

CREATE TABLE seq_region (
  seq_region_id               INT(10) UNSIGNED NOT NULL,
  name                        VARCHAR(40) NOT NULL,
  coord_system_id             INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (seq_region_id),
  UNIQUE KEY name_cs_idx (name, coord_system_id),
  KEY cs_idx (coord_system_id)
) ;

CREATE TABLE coord_system (
  coord_system_id             INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  species_id                  INT(10) UNSIGNED NOT NULL DEFAULT 1,
  name                        VARCHAR(40) NOT NULL,
  version                     VARCHAR(255) DEFAULT NULL,
  rank                        INT NOT NULL,
  attrib                      SET('default_version', 'sequence_level'),
  PRIMARY   KEY (coord_system_id),
  UNIQUE    KEY rank_idx (rank, species_id),
  UNIQUE    KEY name_idx (name, version, species_id),
            KEY species_idx (species_id)
);

CREATE TABLE tagged_variation_feature (
  variation_feature_id int(10) unsigned NOT NULL,
  tagged_variation_feature_id int(10) unsigned DEFAULT NULL,
  population_id int(10) unsigned NOT NULL,
  KEY tag_idx (variation_feature_id),
  KEY tagged_idx (tagged_variation_feature_id),
  KEY population_idx (population_id)
);

CREATE TABLE population(
    population_id int(10) unsigned not null auto_increment,
    name varchar(255),
    size int(10),
    description text,
    collection tinyint(1) default 0,
    freqs_from_gts tinyint(1),
    display enum('LD', 'MARTDISPLAYABLE', 'UNDISPLAYABLE') default 'UNDISPLAYABLE',
    primary key(population_id)
);


CREATE table population_structure (
  super_population_id int(10) unsigned not null,
  sub_population_id int(10) unsigned not null,
  unique super_population_idx (super_population_id, sub_population_id),
  key sub_population_idx (sub_population_id)
);


CREATE table individual(
  individual_id int(10) unsigned not null auto_increment,
  name varchar(255),
  description text,
  gender enum('Male', 'Female', 'Unknown') default 'Unknown' NOT NULL,
  father_individual_id int(10) unsigned,
  mother_individual_id int(10) unsigned,
  individual_type_id int(10) unsigned NOT NULL DEFAULT 0,
  display enum('REFERENCE', 'DEFAULT', 'DISPLAYABLE', 'UNDISPLAYABLE', 'LD', 'MARTDISPLAYABLE') default 'UNDISPLAYABLE',
  primary key(individual_id)
);


CREATE table individual_type(
  individual_type_id int(0) unsigned not null auto_increment,
  name varchar(255) not null,
  description text,
  primary key (individual_type_id)
);
INSERT INTO individual_type (name,description) VALUES ('fully_inbred','multiple organisms have the same genome sequence');
INSERT INTO individual_type (name,description) VALUES ('partly_inbred','single organisms have reduced genome variability due to human intervention');
INSERT INTO individual_type (name,description) VALUES ('outbred','a single organism which breeds freely');
INSERT INTO individual_type (name,description) VALUES ('mutant','a single or multiple organisms with the same genome sequence that have a natural or experimentally induced mutation');


CREATE table individual_population (
  individual_id int(10) unsigned not null,
  population_id int(10) unsigned not null,
  key individual_idx(individual_id),
  key population_idx(population_id)
);

CREATE TABLE individual_synonym (
  synonym_id int(10) unsigned not null auto_increment,
  individual_id int(10) unsigned not null,
  source_id int(10) unsigned not null,
  name varchar(255),
  primary key(synonym_id),
  key individual_idx (individual_id),
  key (name, source_id)
);

CREATE TABLE population_synonym (
  synonym_id int(10) unsigned not null auto_increment,
  population_id int(10) unsigned not null,
  source_id int(10) unsigned not null,
  name varchar(255),
  primary key(synonym_id),
  key population_idx (population_id),
  key (name, source_id)
);

CREATE TABLE population_genotype (
  population_genotype_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  variation_id int(11) unsigned NOT NULL,
  subsnp_id int(11) unsigned DEFAULT NULL,
  genotype_code_id int(11) DEFAULT NULL,
  frequency float DEFAULT NULL,
  population_id int(10) unsigned DEFAULT NULL,
  count int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (population_genotype_id),
  KEY population_idx (population_id),
  KEY variation_idx (variation_id),
  KEY subsnp_idx (subsnp_id)
);

CREATE TABLE tmp_individual_genotype_single_bp (
	variation_id int(10) not null,
	subsnp_id int(15) unsigned,   
	allele_1 char(1),
	allele_2 char(1),
	individual_id int,
	key variation_idx(variation_id),
    key subsnp_idx(subsnp_id),
    key individual_idx(individual_id)
) MAX_ROWS = 100000000;


CREATE table individual_genotype_multiple_bp (
  variation_id int(10) unsigned not null,
  subsnp_id int(15) unsigned,	
  allele_1 varchar(25000),
  allele_2 varchar(25000),
  individual_id int(10) unsigned,
  key variation_idx(variation_id),
  key subsnp_idx(subsnp_id),
  key individual_idx(individual_id)
);

CREATE TABLE compressed_genotype_region (
  individual_id int(10) unsigned NOT NULL,
  seq_region_id int(10) unsigned NOT NULL,
  seq_region_start int(11) NOT NULL,
  seq_region_end int(11) NOT NULL,
  seq_region_strand tinyint(4) NOT NULL,
  genotypes blob,
  KEY pos_idx (seq_region_id,seq_region_start),
  KEY individual_idx (individual_id)
);

CREATE TABLE compressed_genotype_var (
  variation_id int(11) unsigned NOT NULL,
  subsnp_id int(11) unsigned DEFAULT NULL,
  genotypes blob,
  KEY variation_idx (variation_id),
  KEY subsnp_idx (subsnp_id)
);

CREATE TABLE read_coverage (
   seq_region_id int(10) unsigned not null,
   seq_region_start int not null,
   seq_region_end int not null,
   level tinyint not null,
   individual_id int(10) unsigned not null,
   key seq_region_idx(seq_region_id,seq_region_start)   
);

CREATE TABLE structural_variation (
  structural_variation_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  variation_name varchar(255) DEFAULT NULL,
  alias varchar(255) DEFAULT NULL,
	source_id int(10) unsigned NOT NULL,
  study_id int(10) unsigned DEFAULT NULL,
	class_attrib_id int(10) unsigned NOT NULL DEFAULT 0,
	clinical_significance_attrib_id int(10) unsigned DEFAULT NULL,
  validation_status ENUM('validated','not validated','high quality'),
	is_evidence TINYINT(4) DEFAULT 0,
	somatic TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (structural_variation_id),
  KEY name_idx (variation_name),
	KEY source_idx (source_id),
	KEY study_idx (study_id),
	KEY attrib_idx (class_attrib_id),
	KEY clinical_attrib_idx (clinical_significance_attrib_id)
);

CREATE TABLE structural_variation_association (
  structural_variation_id int(10) unsigned NOT NULL,
  supporting_structural_variation_id int(10) unsigned NOT NULL,
  PRIMARY KEY (structural_variation_id, supporting_structural_variation_id),
	KEY structural_variation_idx (structural_variation_id),
	KEY supporting_structural_variation_idx (supporting_structural_variation_id)
);


CREATE table structural_variation_feature (
	structural_variation_feature_id int(10) unsigned NOT NULL AUTO_INCREMENT,
	seq_region_id int(10) unsigned NOT NULL,
	outer_start int,	
	seq_region_start int NOT NULL,
	inner_start int,
	inner_end int,
	seq_region_end int NOT NULL,
	outer_end int,
	seq_region_strand tinyint NOT NULL,
	structural_variation_id int(10) unsigned NOT NULL,
  variation_name varchar(255),
	source_id int(10) unsigned NOT NULL,
  study_id int(10) unsigned DEFAULT NULL,
  class_attrib_id int(10) unsigned NOT NULL DEFAULT 0,
	allele_string longtext DEFAULT NULL,
	is_evidence tinyint(1) NOT NULL DEFAULT 0,
	somatic TINYINT(1) NOT NULL DEFAULT 0,
	breakpoint_order TINYINT(4) DEFAULT NULL,
	length int(10) DEFAULT NULL,
  variation_set_id SET (
          '1','2','3','4','5','6','7','8',
          '9','10','11','12','13','14','15','16',
          '17','18','19','20','21','22','23','24',
          '25','26','27','28','29','30','31','32',
          '33','34','35','36','37','38','39','40',
          '41','42','43','44','45','46','47','48',
          '49','50','51','52','53','54','55','56',
          '57','58','59','60','61','62','63','64'
  ) NOT NULL DEFAULT '',
  PRIMARY KEY (structural_variation_feature_id),
	KEY pos_idx( seq_region_id, seq_region_start, seq_region_end ),
	KEY structural_variation_idx (structural_variation_id),
	KEY source_idx (source_id),
	KEY study_idx (study_id),
	KEY attrib_idx (class_attrib_id),
	KEY variation_set_idx (variation_set_id)
);

CREATE TABLE structural_variation_sample (
	structural_variation_sample_id int(10) unsigned NOT NULL auto_increment,
	structural_variation_id int(10) unsigned NOT NULL,
	individual_id int(10) unsigned DEFAULT NULL,
	strain_id int(10) unsigned DEFAULT NULL,
	primary key (structural_variation_sample_id),
	key structural_variation_idx(structural_variation_id),
	key individual_idx(individual_id),
	key strain_idx(strain_id)
);

CREATE TABLE IF NOT EXISTS variation_set_variation (
	variation_id int(10) unsigned NOT NULL,
	variation_set_id int(10) unsigned NOT NULL,
	PRIMARY KEY (variation_id,variation_set_id),
	KEY variation_set_idx (variation_set_id,variation_id)
);

CREATE TABLE IF NOT EXISTS variation_set (
	variation_set_id int(10) unsigned NOT NULL AUTO_INCREMENT,
	name VARCHAR(255),
	description TEXT,
	short_name_attrib_id INT(10) UNSIGNED DEFAULT NULL,
	PRIMARY KEY (variation_set_id),
	KEY name_idx (name)
);

CREATE TABLE IF NOT EXISTS variation_set_structure (
	variation_set_super int(10) unsigned NOT NULL,
	variation_set_sub int(10) unsigned NOT NULL,
	PRIMARY KEY (variation_set_super,variation_set_sub),
	KEY sub_idx (variation_set_sub,variation_set_super)
);

CREATE TABLE IF NOT EXISTS variation_set_structural_variation (
	structural_variation_id int(10) unsigned NOT NULL,
	variation_set_id int(10) unsigned NOT NULL,
	PRIMARY KEY (structural_variation_id,variation_set_id)
);

CREATE TABLE transcript_variation (
    transcript_variation_id             int(11) unsigned NOT NULL AUTO_INCREMENT,
    variation_feature_id                int(11) unsigned NOT NULL,
    feature_stable_id                   varchar(128) DEFAULT NULL,
    allele_string                       text,
    somatic                             tinyint(1) NOT NULL DEFAULT 0,
    consequence_types                   set (
                                            'splice_acceptor_variant',
                                            'splice_donor_variant',
                                            'stop_lost',
                                            'coding_sequence_variant',
                                            'missense_variant',
                                            'stop_gained',
                                            'synonymous_variant',
                                            'frameshift_variant',
                                            'nc_transcript_variant',
                                            'non_coding_exon_variant',
                                            'mature_miRNA_variant',
                                            'NMD_transcript_variant',
                                            '5_prime_UTR_variant',
                                            '3_prime_UTR_variant',
                                            'incomplete_terminal_codon_variant',
                                            'intron_variant',
                                            'splice_region_variant',
                                            'downstream_gene_variant',
                                            'upstream_gene_variant',
                                            'initiator_codon_variant',
                                            'stop_retained_variant',
                                            'inframe_insertion',
                                            'inframe_deletion',
                                            'transcript_ablation',
                                            'transcript_fusion',
                                            'transcript_amplification',
                                            'transcript_translocation',
                                            'TFBS_ablation',
                                            'TFBS_fusion',
                                            'TFBS_amplification',
                                            'TFBS_translocation',
                                            'regulatory_region_ablation',
                                            'regulatory_region_fusion',
                                            'regulatory_region_amplification',
                                            'regulatory_region_translocation',
                                            'feature_elongation',
                                            'feature_truncation'
                                        ),
    cds_start                           int(11) unsigned,
    cds_end                             int(11) unsigned,
    cdna_start                          int(11) unsigned,
    cdna_end                            int(11) unsigned,
    translation_start                   int(11) unsigned,
    translation_end                     int(11) unsigned,
    distance_to_transcript              int(11) unsigned,
    codon_allele_string                 text,
    pep_allele_string                   text,
    hgvs_genomic                        text,
    hgvs_transcript                     text,
    hgvs_protein                        text,
    polyphen_prediction                 enum('unknown', 'benign', 'possibly damaging', 'probably damaging') DEFAULT NULL,
    polyphen_score                      float DEFAULT NULL,
    sift_prediction                     enum('tolerated', 'deleterious') DEFAULT NULL,
    sift_score                          float DEFAULT NULL,
    PRIMARY KEY                         (transcript_variation_id),
    KEY variation_feature_idx           (variation_feature_id),
    KEY consequence_type_idx            (consequence_types),
    KEY somatic_feature_idx             (feature_stable_id, somatic)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS motif_feature_variation (
    motif_feature_variation_id          int(11) unsigned NOT NULL AUTO_INCREMENT,
    variation_feature_id                int(11) unsigned NOT NULL,
    feature_stable_id                   varchar(128) DEFAULT NULL,
    motif_feature_id                    int(11) unsigned NOT NULL,
    allele_string                       text,
    somatic                             tinyint(1) NOT NULL DEFAULT 0,
    consequence_types                   set (
                                            'splice_acceptor_variant',
                                            'splice_donor_variant',
                                            'stop_lost',
                                            'coding_sequence_variant',
                                            'missense_variant',
                                            'stop_gained',
                                            'synonymous_variant',
                                            'frameshift_variant',
                                            'nc_transcript_variant',
                                            'non_coding_exon_variant',
                                            'mature_miRNA_variant',
                                            'NMD_transcript_variant',
                                            '5_prime_UTR_variant',
                                            '3_prime_UTR_variant',
                                            'incomplete_terminal_codon_variant',
                                            'intron_variant',
                                            'splice_region_variant',
                                            'downstream_gene_variant',
                                            'upstream_gene_variant',
                                            'initiator_codon_variant',
                                            'stop_retained_variant',
                                            'inframe_insertion',
                                            'inframe_deletion',
                                            'transcript_ablation',
                                            'transcript_fusion',
                                            'transcript_amplification',
                                            'transcript_translocation',
                                            'TF_binding_site_variant',
                                            'TFBS_ablation',
                                            'TFBS_fusion',
                                            'TFBS_amplification',
                                            'TFBS_translocation',
                                            'regulatory_region_variant',
                                            'regulatory_region_ablation',
                                            'regulatory_region_fusion',
                                            'regulatory_region_amplification',
                                            'regulatory_region_translocation',
                                            'feature_elongation',
                                            'feature_truncation'
                                        ),
    motif_name                          text,
    motif_start                         int(11) unsigned,
    motif_end                           int(11) unsigned,
    motif_score_delta                   float DEFAULT NULL,
    in_informative_position             tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY                         (motif_feature_variation_id),
    KEY variation_feature_idx           (variation_feature_id),
    KEY consequence_type_idx            (consequence_types),
    KEY somatic_feature_idx             (feature_stable_id, somatic)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS regulatory_feature_variation (
    regulatory_feature_variation_id     int(11) unsigned NOT NULL AUTO_INCREMENT,
    variation_feature_id                int(11) unsigned NOT NULL,
    feature_stable_id                   varchar(128) DEFAULT NULL,
    feature_type                        text, 
    allele_string                       text,
    somatic                             tinyint(1) NOT NULL DEFAULT 0,
    consequence_types                   set (
                                            'splice_acceptor_variant',
                                            'splice_donor_variant',
                                            'stop_lost',
                                            'coding_sequence_variant',
                                            'missense_variant',
                                            'stop_gained',
                                            'synonymous_variant',
                                            'frameshift_variant',
                                            'nc_transcript_variant',
                                            'non_coding_exon_variant',
                                            'mature_miRNA_variant',
                                            'NMD_transcript_variant',
                                            '5_prime_UTR_variant',
                                            '3_prime_UTR_variant',
                                            'incomplete_terminal_codon_variant',
                                            'intron_variant',
                                            'splice_region_variant',
                                            'downstream_gene_variant',
                                            'upstream_gene_variant',
                                            'initiator_codon_variant',
                                            'stop_retained_variant',
                                            'inframe_insertion',
                                            'inframe_deletion',
                                            'transcript_ablation',
                                            'transcript_fusion',
                                            'transcript_amplification',
                                            'transcript_translocation',
                                            'TF_binding_site_variant',
                                            'TFBS_ablation',
                                            'TFBS_fusion',
                                            'TFBS_amplification',
                                            'TFBS_translocation',
                                            'regulatory_region_variant',
                                            'regulatory_region_ablation',
                                            'regulatory_region_fusion',
                                            'regulatory_region_amplification',
                                            'regulatory_region_translocation',
                                            'feature_elongation',
                                            'feature_truncation'
                                        ),
    PRIMARY KEY                         (regulatory_feature_variation_id),
    KEY variation_feature_idx           (variation_feature_id),
    KEY consequence_type_idx            (consequence_types),
    KEY somatic_feature_idx             (feature_stable_id, somatic)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE table source(
	source_id int(10) unsigned not null auto_increment,
	name varchar(24) not null,
	version int,
	description varchar(255),
	url varchar(255),
	type ENUM('chip','lsdb') DEFAULT NULL,
  somatic_status ENUM ('germline','somatic','mixed') DEFAULT 'germline',
  data_types SET('variation','variation_synonym','structural_variation','phenotype_feature','study') DEFAULT NULL,
	primary key( source_id )
);

CREATE TABLE study (
	study_id int(10) unsigned not null auto_increment,
	source_id int(10) unsigned not null,
	name varchar(255) DEFAULT null,
	description text DEFAULT NULL,
	url varchar(255) DEFAULT NULL,
	external_reference varchar(255) DEFAULT NULL,
	study_type varchar(255) DEFAULT NULL,
	primary key( study_id ),
	key source_idx (source_id)
);

CREATE TABLE associate_study (
	study1_id int(10) unsigned not null,
	study2_id int(10) unsigned not null,
	primary key( study1_id,study2_id )
);

CREATE TABLE study_variation (
   variation_id int(10) unsigned not null,
   study_id int(10) unsigned not null,
   PRIMARY KEY study_variation_idx (variation_id, study_id)
);

CREATE TABLE publication(
  publication_id int(10) unsigned not null auto_increment, 
  title          varchar(255),
  authors        varchar(255),
  pmid           int(10),
  pmcid          varchar(255),
  year           int(10) unsigned,
  doi            varchar(50),
  ucsc_id        varchar(50),
  PRIMARY KEY ( publication_id ),
  KEY pmid_idx (pmid),
  KEY doi_idx (doi)
);

CREATE TABLE variation_citation (
   variation_id int(10) unsigned not null,
   publication_id int(10) unsigned not null,
   PRIMARY KEY variation_citation_idx (variation_id, publication_id)
);

CREATE TABLE meta_coord (
  table_name      VARCHAR(40) NOT NULL,
  coord_system_id INT(10) UNSIGNED NOT NULL,
  max_length		  INT,
  UNIQUE(table_name, coord_system_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE meta (
  meta_id 		INT(10) UNSIGNED not null auto_increment,
  species_id  INT UNSIGNED DEFAULT 1,
  meta_key    varchar( 40 ) not null,
  meta_value  varchar( 255 ) not null,
  PRIMARY KEY( meta_id ),
  UNIQUE KEY species_key_value_idx (species_id, meta_key, meta_value ),
  KEY species_value_idx (species_id, meta_value )
);
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'schema_type', 'variation'), (NULL, 'schema_version', '74');
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'patch', 'patch_73_74_a.sql|schema version');
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'patch', 'patch_73_74_b.sql|Add doi and UCSC id to publication table');
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'patch', 'patch_73_74_c.sql|Add clinical_significance to variation_feature table');
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'patch', 'patch_73_74_d.sql|Add data_types to source table');
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL, 'patch', 'patch_73_74_e.sql|Update indexes for the phenotype table');

CREATE TABLE failed_description(
 failed_description_id int(10) unsigned not null AUTO_INCREMENT,
 description  text not null,
 PRIMARY KEY (failed_description_id)
);

CREATE TABLE failed_variation (
  failed_variation_id int(11) NOT NULL AUTO_INCREMENT,
  variation_id int(10) unsigned NOT NULL,
  failed_description_id int(10) unsigned NOT NULL,
  PRIMARY KEY (failed_variation_id),
  UNIQUE KEY variation_idx (variation_id,failed_description_id)
);

CREATE TABLE failed_allele (
  failed_allele_id int(11) NOT NULL AUTO_INCREMENT,
  allele_id int(10) unsigned NOT NULL,
  failed_description_id int(10) unsigned NOT NULL,
  PRIMARY KEY (failed_allele_id),
  UNIQUE KEY allele_idx (allele_id,failed_description_id)
);

CREATE TABLE failed_structural_variation (
  failed_structural_variation_id int(11) NOT NULL AUTO_INCREMENT,
  structural_variation_id int(10) unsigned NOT NULL,
  failed_description_id int(10) unsigned NOT NULL,
  PRIMARY KEY (failed_structural_variation_id),
  UNIQUE KEY structural_variation_idx (structural_variation_id,failed_description_id)
);

CREATE TABLE strain_gtype_poly (
  variation_id int(10) unsigned NOT NULL,
  sample_name varchar(100) DEFAULT NULL,
  PRIMARY KEY (variation_id)
);

CREATE TABLE attrib_type (
    attrib_type_id    SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
    code              VARCHAR(20) NOT NULL DEFAULT '',
    name              VARCHAR(255) NOT NULL DEFAULT '',
    description       TEXT,
    PRIMARY KEY (attrib_type_id),
    UNIQUE KEY code_idx (code)
);

CREATE TABLE attrib (
    attrib_id           INT(11) UNSIGNED NOT NULL DEFAULT 0,
    attrib_type_id      SMALLINT(5) UNSIGNED NOT NULL DEFAULT 0,
    value               TEXT NOT NULL,
    PRIMARY KEY (attrib_id),
    UNIQUE KEY type_val_idx (attrib_type_id, value(40))
);

CREATE TABLE attrib_set (
    attrib_set_id       INT(11) UNSIGNED NOT NULL DEFAULT 0,
    attrib_id           INT(11) UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY set_idx (attrib_set_id, attrib_id),
    KEY attrib_idx (attrib_id)
);

CREATE TABLE protein_function_predictions (
    translation_md5_id int(11) unsigned NOT NULL,
    analysis_attrib_id int(11) unsigned NOT NULL,
    prediction_matrix mediumblob,
    PRIMARY KEY (translation_md5_id, analysis_attrib_id)
);

CREATE TABLE translation_md5 (
    translation_md5_id int(11) NOT NULL AUTO_INCREMENT,
    translation_md5 char(32) NOT NULL,
    PRIMARY KEY (translation_md5_id),
    UNIQUE KEY md5_idx (translation_md5)
);
ALTER TABLE allele ADD FOREIGN KEY  (subsnp_id) REFERENCES subsnp_handle (subsnp_id);
ALTER TABLE allele ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE allele ADD FOREIGN KEY  (allele_code_id) REFERENCES allele_code (allele_code_id);
ALTER TABLE allele ADD FOREIGN KEY  (population_id) REFERENCES population (population_id);
ALTER TABLE allele ADD FOREIGN KEY  (frequency_submitter_handle) REFERENCES submitter_handle (handle_id);
ALTER TABLE associate_study ADD FOREIGN KEY  (study1_id) REFERENCES study (study_id);
ALTER TABLE associate_study ADD FOREIGN KEY  (study2_id) REFERENCES study (study_id);
ALTER TABLE attrib ADD FOREIGN KEY  (attrib_type_id) REFERENCES attrib_type (attrib_type_id);
ALTER TABLE attrib_set ADD FOREIGN KEY  (attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE compressed_genotype_region ADD FOREIGN KEY  (individual_id) REFERENCES individual (individual_id);
ALTER TABLE compressed_genotype_region ADD FOREIGN KEY  (seq_region_id) REFERENCES seq_region (seq_region_id);
ALTER TABLE compressed_genotype_var ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE compressed_genotype_var ADD FOREIGN KEY  (subsnp_id) REFERENCES subsnp_handle (subsnp_id);
ALTER TABLE failed_allele ADD FOREIGN KEY  (allele_id) REFERENCES allele (allele_id);
ALTER TABLE failed_allele ADD FOREIGN KEY  (failed_description_id) REFERENCES failed_description (failed_description_id);
ALTER TABLE failed_variation ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE failed_variation ADD FOREIGN KEY  (failed_description_id) REFERENCES failed_description (failed_description_id);
ALTER TABLE failed_structural_variation ADD FOREIGN KEY  (structural_variation_id) REFERENCES structural_variation (structural_variation_id);
ALTER TABLE failed_structural_variation ADD FOREIGN KEY  (failed_description_id) REFERENCES failed_description (failed_description_id);
ALTER TABLE genotype_code ADD FOREIGN KEY  (allele_code_id) REFERENCES allele_code (allele_code_id);
ALTER TABLE individual ADD FOREIGN KEY  (father_individual_id) REFERENCES individual (individual_id);
ALTER TABLE individual ADD FOREIGN KEY  (mother_individual_id) REFERENCES individual (individual_id);
ALTER TABLE individual ADD FOREIGN KEY  (individual_type_id) REFERENCES individual_type (individual_type_id);
ALTER TABLE individual_genotype_multiple_bp ADD FOREIGN KEY  (subsnp_id) REFERENCES subsnp_handle (subsnp_id);
ALTER TABLE individual_genotype_multiple_bp ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE individual_genotype_multiple_bp ADD FOREIGN KEY  (individual_id) REFERENCES individual (individual_id);
ALTER TABLE individual_population ADD FOREIGN KEY  (individual_id) REFERENCES individual (individual_id);
ALTER TABLE individual_population ADD FOREIGN KEY  (population_id) REFERENCES population (population_id);
ALTER TABLE population_genotype ADD FOREIGN KEY  (subsnp_id) REFERENCES subsnp_handle (subsnp_id);
ALTER TABLE population_genotype ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE population_genotype ADD FOREIGN KEY  (genotype_code_id) REFERENCES genotype_code (genotype_code_id);
ALTER TABLE population_genotype ADD FOREIGN KEY  (population_id) REFERENCES population (population_id);
ALTER TABLE population_structure ADD FOREIGN KEY  (super_population_id) REFERENCES population (population_id);
ALTER TABLE population_structure ADD FOREIGN KEY  (sub_population_id) REFERENCES population (population_id);
ALTER TABLE protein_function_predictions ADD FOREIGN KEY  (translation_md5_id) REFERENCES translation_md5 (translation_md5_id);
ALTER TABLE protein_function_predictions ADD FOREIGN KEY  (analysis_attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE read_coverage ADD FOREIGN KEY  (individual_id) REFERENCES individual (individual_id);
ALTER TABLE read_coverage ADD FOREIGN KEY  (seq_region_id) REFERENCES seq_region (seq_region_id);
ALTER TABLE individual_synonym ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE individual_synonym ADD FOREIGN KEY  (individual_id) REFERENCES individual (individual_id);
ALTER TABLE population_synonym ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE population_synonym ADD FOREIGN KEY  (population_id) REFERENCES population (population_id);
ALTER TABLE seq_region ADD FOREIGN KEY  (coord_system_id) REFERENCES coord_system (coord_system_id);
ALTER TABLE structural_variation ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE structural_variation ADD FOREIGN KEY  (study_id) REFERENCES study (study_id);
ALTER TABLE structural_variation ADD FOREIGN KEY  (class_attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE structural_variation_association ADD FOREIGN KEY  (structural_variation_id) REFERENCES structural_variation (structural_variation_id);
ALTER TABLE structural_variation_association ADD FOREIGN KEY  (supporting_structural_variation_id) REFERENCES structural_variation (structural_variation_id);
ALTER TABLE structural_variation_feature ADD FOREIGN KEY  (seq_region_id) REFERENCES seq_region (seq_region_id);
ALTER TABLE structural_variation_feature ADD FOREIGN KEY  (structural_variation_id) REFERENCES structural_variation (structural_variation_id);
ALTER TABLE structural_variation_feature ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE structural_variation_feature ADD FOREIGN KEY  (study_id) REFERENCES study (study_id);
ALTER TABLE structural_variation_feature ADD FOREIGN KEY  (class_attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE structural_variation_sample ADD FOREIGN KEY  (individual_id) REFERENCES individual (individual_id);
ALTER TABLE structural_variation_sample ADD FOREIGN KEY  (strain_id) REFERENCES individual (individual_id);
ALTER TABLE structural_variation_sample ADD FOREIGN KEY  (structural_variation_id) REFERENCES structural_variation (structural_variation_id);
ALTER TABLE study ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE study_variation ADD FOREIGN KEY  (study_id) REFERENCES study (study_id);
ALTER TABLE study_variation ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE tagged_variation_feature ADD FOREIGN KEY  (variation_feature_id) REFERENCES variation_feature (variation_feature_id);
ALTER TABLE tagged_variation_feature ADD FOREIGN KEY  (population_id) REFERENCES population (population_id);
ALTER TABLE transcript_variation ADD FOREIGN KEY  (variation_feature_id) REFERENCES variation_feature (variation_feature_id);
ALTER TABLE motif_feature_variation ADD FOREIGN KEY  (variation_feature_id) REFERENCES variation_feature (variation_feature_id);
ALTER TABLE regulatory_feature_variation ADD FOREIGN KEY  (variation_feature_id) REFERENCES variation_feature (variation_feature_id);
ALTER TABLE variation ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE variation ADD FOREIGN KEY  (class_attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE phenotype_feature ADD FOREIGN KEY  (source_id) REFERENCES study (study_id);
ALTER TABLE phenotype_feature ADD FOREIGN KEY  (study_id) REFERENCES study (study_id);
ALTER TABLE phenotype_feature ADD FOREIGN KEY  (object_id) REFERENCES variation (name);
ALTER TABLE phenotype_feature ADD FOREIGN KEY  (object_id) REFERENCES structural_variation (variation_name);
ALTER TABLE phenotype_feature ADD FOREIGN KEY  (phenotype_id) REFERENCES phenotype (phenotype_id);
ALTER TABLE phenotype_feature ADD FOREIGN KEY  (seq_region_id) REFERENCES seq_region (seq_region_id);
ALTER TABLE phenotype_feature_attrib ADD FOREIGN KEY  (phenotype_feature_id) REFERENCES phenotype_feature (phenotype_feature_id);
ALTER TABLE phenotype_feature_attrib ADD FOREIGN KEY  (attrib_type_id) REFERENCES attrib_type (attrib_type_id);
ALTER TABLE variation_citation ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE variation_citation ADD FOREIGN KEY  (publication_id) REFERENCES publication (publication_id);
ALTER TABLE variation_feature ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE variation_feature ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE variation_feature ADD FOREIGN KEY  (seq_region_id) REFERENCES seq_region (seq_region_id);
ALTER TABLE variation_feature ADD FOREIGN KEY  (class_attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE variation_set ADD FOREIGN KEY  (short_name_attrib_id) REFERENCES attrib (attrib_id);
ALTER TABLE variation_set_structural_variation ADD FOREIGN KEY  (structural_variation_id) REFERENCES structural_variation (structural_variation_id);
ALTER TABLE variation_set_structural_variation ADD FOREIGN KEY  (variation_set_id) REFERENCES variation_set (variation_set_id);
ALTER TABLE variation_set_structure ADD FOREIGN KEY  (variation_set_super) REFERENCES variation_set (variation_set_id);
ALTER TABLE variation_set_structure ADD FOREIGN KEY  (variation_set_sub) REFERENCES variation_set (variation_set_id);
ALTER TABLE variation_set_variation ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
ALTER TABLE variation_set_variation ADD FOREIGN KEY  (variation_set_id) REFERENCES variation_set (variation_set_id);
ALTER TABLE variation_synonym ADD FOREIGN KEY  (subsnp_id) REFERENCES subsnp_handle (subsnp_id);
ALTER TABLE variation_synonym ADD FOREIGN KEY  (source_id) REFERENCES source (source_id);
ALTER TABLE variation_synonym ADD FOREIGN KEY  (variation_id) REFERENCES variation (variation_id);
