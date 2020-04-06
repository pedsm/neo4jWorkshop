// Create a constraint
CREATE CONSTRAINT ON (user:USER) ASSERT user.email IS UNIQUE

// Create user
CREATE (john:USER {
    name: "John",
    email: "john@example.com"
}) RETURN john

// Create a second user
CREATE (peter:USER {
    name: "Peter",
    email: "peter@example.com"
}) RETURN peter

// Create a post 
MATCH (john:USER {email: "john@example.com"})
CREATE (john)<-[r:CREATED_BY]-(post:POST {
  title: "My first post",
  content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris consequat nunc nec fermentum iaculis. Nulla facilisi. Morbi pellentesque auctor neque."
}) RETURN john, r, post

// Creating a follow
MATCH (john:USER {email: "john@example.com"}), 
(peter:USER {email: "peter@example.com"})
CREATE (peter)-[r:FOLLOWS]->(john)
RETURN john, r, peter

// GET all posts 
MATCH (p:POST) RETURN p.title, ID(p)

// Creating a like 
MATCH (peter:USER {email: "peter@example.com"}), (post:POST)
WHERE ID(post) = (Fill this in with the correct ID from the previous query)
CREATE (peter)-[r:LIKES]->(post)
RETURN peter, r, post

// Let's fetch everything 
MATCH (n)-[r]-() RETURN n,r

// Mapping users
MATCH (u:USER) RETURN u{
    .name,
    .email
}

// Getting users with posts

MATCH (u:USER {email:"john@example.com"})<-[:CREATED_BY]-(p:POST) 
RETURN u{
    .name,
    .email,
    posts: collect(p.title)
}

// Mapping posts by user X
MATCH (u:USER {email:"peter@example.com"})-[:FOLLOWS]->(:USER)--(p:POST) 
RETURN p{
    id: ID(p),
    .title,
    .content
}