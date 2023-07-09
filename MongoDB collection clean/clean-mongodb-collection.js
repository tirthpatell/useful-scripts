const { MongoClient } = require('mongodb');

const uri = 'url'; // Replace 'url' with the actual MongoDB server URL
const databaseName = 'dbName'; // Replace 'db' with the actual DB name
const collectionName = 'CollectionName'; // Replace 'collection' with the actual collection name for the given DB

// Function to delete all documents in the specified collection
async function deleteCollectionData() {
  try {
    const client = await MongoClient.connect(uri, { useNewUrlParser: true });
    // Connect to the MongoDB server using the provided URL
    
    const database = client.db(databaseName);
    // Access the specified database
    
    const collection = database.collection(collectionName);
    // Access the specified collection within the database
    
    const result = await collection.deleteMany({});
    // Delete all documents in the collection by passing an empty filter ({}) to deleteMany
    
    console.log(`${result.deletedCount} documents deleted.`);
    // Print the number of documents deleted
    
    client.close();
    // Close the MongoDB connection
  } catch (error) {
    console.error('Error:', error);
    // If an error occurs, log the error message to the console
  }
}

deleteCollectionData();
// Call the deleteCollectionData function to initiate the deletion process
