create table query_log (
  query_log_id int unsigned not null auto_increment primary key,
  num_found int,
  query text,
  params text,
  ip text,
  user_id text,
  time double,
  date timestamp
);
