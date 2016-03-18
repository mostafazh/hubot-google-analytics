chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'google-analytics', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/google-analytics')(@robot)

  it 'registers a hear listener', ->
    expect(@robot.hear).to.have.been.calledWith(/pageviews list/i)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/pageviews\s+(\d+)\s+(\w+)\s*(\w*)/i)

  it 'registers a hear listener', ->
    expect(@robot.hear).to.have.been.calledWith(/analytics profiles list/i)
