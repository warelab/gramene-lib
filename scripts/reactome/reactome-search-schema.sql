create table reactome (
  reactome_id int primary key auto_increment,
  search_term	text,
  pathway_id int,
  object_id int
);
