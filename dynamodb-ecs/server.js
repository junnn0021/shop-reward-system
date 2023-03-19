const fastify = require('fastify')()

fastify.register(require('./reward'))
fastify.register(require('./reward_day'))
fastify.register(require('./attendance'))

const start = async () => {
  try {
    await fastify.listen(3000, '0.0.0.0')
    console.log('Server started on port 3000')
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

start()