exports.handler = async (event) => {
  const email = event.email;
  console.log(email);
};

const {
  connectDb,
  queries: { getProduct, setStock },
} = require("./database");