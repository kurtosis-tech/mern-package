const ORIGIN = '*'
const PORT = process.env.PORT || 8080

const MONGO_URI = process.env.MONGO_URI
const MONGO_OPTIONS = {}

const JWT_SECRET = process.env.JWT_SECRET || 'unsafe_secret'

module.exports = {
  ORIGIN,
  PORT,
  MONGO_URI,
  MONGO_OPTIONS,
  JWT_SECRET,
}
