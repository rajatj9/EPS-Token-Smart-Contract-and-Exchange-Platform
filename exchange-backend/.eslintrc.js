module.exports = {
    extends: 'airbnb-base',
    rules: {
        indent: ['error', 4],
        semi: ['error', 'never'],
        'eol-last': ['error', 'never'],
        'comma-dangle': ['error', 'never'],
        'no-underscore-dangle': 0
    },
    env: {
        jest: true
    }
}