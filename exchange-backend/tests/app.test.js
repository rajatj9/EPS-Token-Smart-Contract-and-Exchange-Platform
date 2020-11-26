const request = require('supertest')
const app = require('../src/app')

test('Should work', async () => {
    const response = await request(app)
        .get('/')
        .expect(200)

    expect(response.body.data).toBe('simple endpoint')
})