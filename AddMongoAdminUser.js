db.createUser({
  user: "admin",               // Username for the admin user
  pwd: "your-password",        // Strong password for the admin user
  roles: [{ role: "root", db: "admin" }]  // Assign the 'root' role to this user
})
