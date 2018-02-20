// From https://tbgraph.wordpress.com/2017/08/31/neo4j-london-tube-system-analysis/
// Setup constrains in order to improve speed
CREATE CONSTRAINT ON (s:Station) ASSERT s.id is unique;
CREATE INDEX ON :Station(name);

// Load stations
LOAD CSV WITH HEADERS FROM
"https://raw.githubusercontent.com/nicola/tubemaps/master/datasets/london.stations.csv" as row
MERGE (s:Station{id:row.id})
ON CREATE SET s.name = row.name,
              s.latitude=row.latitude,
              s.longitude=row.longitude,
              s.zone=row.zone,
              s.total_lines=row.total_lines

// Load train lines
LOAD CSV WITH HEADERS FROM
"https://raw.githubusercontent.com/nicola/tubemaps/master/datasets/london.connections.csv" as row
MATCH (s1:Station{id:row.station1})
MATCH (s2:Station{id:row.station2})
MERGE (s1)-[:CONNECTION{time:row.time,line:row.line}]->(s2)
MERGE (s1)<-[:CONNECTION{time:row.time,line:row.line}]-(s2)

// Some analisis
MATCH (n:Station)--(n1) RETURN n.name as station, count(distinct(n1)) as connections order by connections desc LIMIT 15

// Find stations 1 hop away from Baker Street
MATCH (s:Station {name: "Baker Street"})-[*..1]-(s2) RETURN s,s2

// Find the most distance station to Baker Street by taking the shortest time to each
MATCH (n:Station {name:'Baker Street'})
CALL algo.shortestPaths.stream(n, 'time')
YIELD nodeId, distance
MATCH (s:Station) where id(s)=nodeId
RETURN s.name as station,distance as time 
ORDER BY time desc LIMIT 152

// Find the longest distance between two stations by using shortest paths
CALL algo.allShortestPaths.stream('time',
{nodeQuery:'Station',relationshipQuery:'CONNECTION',defaultValue:1.0})
YIELD sourceNodeId, targetNodeId, distance
WITH sourceNodeId, targetNodeId, distance 
ORDER BY distance desc LIMIT 20

// We filter out duplicates
WHERE sourceNodeId > targetNodeId
MATCH (s1:Station),(s2:Station) 
WHERE id(s1)=sourceNodeId AND id(s2)=targetNodeId
RETURN s1.name as station1,s2.name as station2,distance as time

// Use page rank to define the most relevant stations
CALL algo.pageRank.stream('Stations', 'CONNECTION', {iterations:100, dampingFactor:0.85})
YIELD node, score
RETURN node.name as NAME ,score order by score desc limit 20