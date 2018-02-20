// Create two nodes
CREATE (n:PERSON { name: "Pedro" });
CREATE (n:PERSON { name: "Jonny" }) RETURN n;

// Retreive all nodes
MATCH (n) RETURN n;

// Create a relationship
MATCH (a:PERSON), (b:PERSON)
WHERE 
a.name = "Pedro" AND
b.name = "Jonny"
CREATE (a)-[r:FRIENDS]->(b)
RETURN r;

// Create a relaionship in a facier way
MERGE (pedro:PERSON {name: "Pedro"})-[r:friends_with]->(jonny:PERSON {name:"Jonny"}) RETURN r;

// Delete all data
MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r;