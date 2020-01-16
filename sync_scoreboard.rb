#!/usr/bin/env ruby

require 'pg'
require 'json'

uri = 'postgres://postgres:postgres@localhost:5656/cdp_core_db'

query = <<~SQL
  select string_field_value_6 as email, string_field_value_14 as score
  from entities
  where string_field_value_6 is not null
  order by 2 desc;
SQL

loop do
  pg_conn = PG.connect(uri)

  results = pg_conn.exec(query).to_a.map do |r|
    r['score'] = r['score'].to_i
    r
  end

  File.open("scores.js","w+") do |f|
    f.write("window.scores = #{results.to_json}")
  end

  pg_conn.close
  sleep 1
end
