const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect('mongodb+srv://<Username>:<Password>@cluster0.id2qofj.mongodb.net/mark_management_system?retryWrites=true&w=majority', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Define MongoDB Schema
const markSchema = new mongoose.Schema({
  name: { type: String, required: true },
  sinhala: { type: Number, required: true },
  tamil: { type: Number, required: true },
  maths: { type: Number, required: true },
  science: { type: Number, required: true },
  ict: { type: Number, required: true },
  art: { type: Number, required: true }
});

const Mark = mongoose.model('Mark', markSchema);

// Routes

// Route to add marks
app.post('/marks', async (req, res) => {
  try {
    const { name, sinhala, tamil, maths, science, ict, art } = req.body;
    // Validate input data
    if (!name || !sinhala || !tamil || !maths || !science || !ict || !art) {
      return res.status(400).json({ message: "All fields are required" });
    }
    // Create new mark object
    const mark = new Mark({ name, sinhala, tamil, maths, science, ict, art });
    await mark.save();
    res.status(201).json(mark);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Route to get all marks
app.get('/marks', async (req, res) => {
  try {
    const marks = await Mark.find();
    res.status(200).json(marks);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Route to delete a mark by ID
app.delete('/marks/:id', async (req, res) => {
  try {
    const { id } = req.params;
    console.log(`Attempting to delete mark with ID: ${id}`);
    const mark = await Mark.findById(id);
    if (!mark) {
      console.log(`Mark with ID ${id} not found`);
      return res.status(404).json({ message: "Mark not found" });
    }
    await mark.deleteOne();
    console.log(`Mark with ID ${id} deleted successfully`);
    res.status(200).json({ message: "Mark deleted successfully" });
  } catch (err) {
    console.error(`Error deleting mark: ${err.message}`);
    res.status(500).json({ message: err.message });
  }
});

// Route to update a mark by ID
app.put('/marks/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, sinhala, tamil, maths, science, ict, art } = req.body;
    // Validate input data
    if (!name || !sinhala || !tamil || !maths || !science || !ict || !art) {
      return res.status(400).json({ message: "All fields are required" });
    }
    const mark = await Mark.findById(id);
    if (!mark) {
      return res.status(404).json({ message: "Mark not found" });
    }
    // Update mark fields
    mark.name = name;
    mark.sinhala = sinhala;
    mark.tamil = tamil;
    mark.maths = maths;
    mark.science = science;
    mark.ict = ict;
    mark.art = art;
    // Save updated mark
    await mark.save();
    res.status(200).json(mark);
  } catch (err) {
    console.error(`Error updating mark: ${err.message}`);
    res.status(500).json({ message: err.message });
  }
});


// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
