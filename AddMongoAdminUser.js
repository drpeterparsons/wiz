use admin;
db.createUser({
  user: "admin",
  pwd: "Admin123!",
  roles: [
    { role: "root", db: "admin" }
  ]
});
