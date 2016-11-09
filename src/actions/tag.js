'use strict'

const {
  CHANGED, CREATE, INSERT, REMOVE, SAVE, HIDE, SHOW, LOAD, UPDATE, PRUNE
} = require('../constants/tag')

const { EDIT } = require('../constants/ui')

module.exports = {

  new(payload, meta) {
    return {
      type: EDIT.START,
      payload: {
        tag: { name: '', ...payload, }
      },
      meta
    }
  },

  create(payload, meta) {
    return {
      type: CREATE,
      payload,
      meta: {
        async: true,
        record: true,
        ...meta
      }
    }
  },

  insert(payload, meta = {}) {
    return { type: INSERT, payload, meta: { ipc: CHANGED, ...meta } }
  },

  remove(payload, meta) {
    return { type: REMOVE, payload, meta: { ipc: CHANGED, ...meta } }
  },

  save(payload, meta) {
    return { type: SAVE, payload, meta: { async: true, record: true, ...meta } }
  },

  hide(payload, meta) {
    return {
      type: HIDE,
      payload,
      meta: {
        async: true,
        record: true,
        ...meta
      }
    }
  },

  prune(payload, meta) {
    return { type: PRUNE, payload, meta: { async: true, ...meta } }
  },

  show(payload, meta) {
    return { type: SHOW, payload, meta: { async: true, ...meta } }
  },

  load(payload, meta) {
    return {
      type: LOAD,
      payload,
      meta: { async: true, ipc: CHANGED, ...meta }
    }
  },

  update(payload, meta) {
    return { type: UPDATE, payload, meta: { ipc: CHANGED, ...meta } }
  }
}

