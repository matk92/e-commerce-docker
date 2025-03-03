// Fichier: tests/jest.setup.js
process.env.NODE_ENV = 'test';

import mongoose from 'mongoose';

let mongod;

beforeAll(async () => {
  try {
    const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017/test';

    // Vérifier et déconnecter si déjà connecté
    if (mongoose.connection.readyState !== 0) {
      await mongoose.disconnect();
    }

    await mongoose.connect(uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
  } catch (error) {
    console.error('Error setting up test database:', error);
    throw error;
  }
});

afterAll(async () => {
  try {
    if (mongoose.connection.readyState !== 0) {
      await mongoose.disconnect();
    }
  } catch (error) {
    console.error('Error cleaning up test database:', error);
  }
});

beforeEach(async () => {
  if (!mongoose.connection) {
    return;
  }
  try {
    const collections = mongoose.connection.collections;
    for (const key in collections) {
      await collections[key].deleteMany();
    }
  } catch (error) {
    console.error('Error clearing collections:', error);
  }
});
