const express = require("express");
const app = express();
app.use(express.urlencoded({ extended: true }));

const port = 3500;

const cors = require("cors");
app.use(cors());

const { Pool } = require("pg");
const pool = new Pool({
  user: "user_3500",
  host: "db",
  database: "crm_3500", 
  password: "pass_3500",
  port: 5432,
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

app.get("/customers", async (req, res) => {
  try {
    const customerData = await pool.query("SELECT * FROM customers");
    res.send(customerData.rows);
  } catch (err) {
    console.error(err);
    res.send("Error " + err);
  }
});

app.get("/customer/:customerId", async (req, res) => {
  try{
    const customerData = await pool.query(`SELECT * FROM customers WHERE customer_id = ${req.params.customerId}`);
    res.send(customerData.rows);
  }catch(err){
    console.error(err);
    res.send("Error " + err);
  }
})

app.use(express.urlencoded({ extended: true }));
app.use(express.json());


app.post("/add-customer", async (req, res) => {
  try {
    const { companyName, industry, contact, location } = req.body;
    const newCustomer = await pool.query(
      "INSERT INTO customers (company_name, industry, contact, location) VALUES ($1, $2, $3, $4) RETURNING *",
      [companyName, industry, contact, location]
    );
    res.json({ success: true, customer: newCustomer.rows[0] });
  } catch (err) {
    console.error(err);
    res.json({ success: false });
  }
});

app.delete("/customer/:customerId", async (req, res) => {
  try{
    const customerId = req.params.customerId;
    await pool.query(`DELETE FROM customers WHERE customer_id = ${customerId}`);
    res.json({ success: true, deletedCustomerId: customerId});
  }catch(err){
    console.error(err);
    res.json({ success: false });
  }
});

app.put("/customer/:customerId", async (req, res) => {
  try{
    const customerId = req.params.customerId;
    const { companyName, industry, contact, location } = req.body;
    const updateCustomer = await pool.query(
      `UPDATE customers SET company_name = $1, industry = $2, contact = $3, location = $4 WHERE customer_id = ${customerId} RETURNING *`,
      [companyName, industry, contact, location]
    );
    res.json({ success: true, cutomer: updateCustomer.rows});
  }catch(err){
    console.error(err);
    res.json({ success: false });
  }
})

app.use(express.static("public"));
