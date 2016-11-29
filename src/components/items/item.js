'use strict'

const React = require('react')
const { Component, PropTypes } = React
const { connect } = require('react-redux')
const { FormattedMessage } = require('react-intl')
const { Toolbar } = require('../toolbar')
const { Tab, Tabs } = require('../tabs')
const { NoteList } = require('../notelist')
const { PanelGroup, Panel } = require('../panel')
const { Resizable } = require('../resizable')
const { PhotoToolbar, PhotoList } = require('../photo')
const { Viewer } = require('../viewer')
const { Fields } = require('../metadata')
const { getSelectedItem } = require('../../selectors/items')
const { frameless } = ARGS
const act = require('../../actions')

const {
  IconMetadata, IconNote, IconTag, IconPlus
} = require('../icons')


class Item extends Component {
  constructor(props) {
    super(props)
  }


  get disabled() {
    return !this.props.item || !!this.props.item.deleted
  }

  handleMetadataTabSelect = () => {
    if (this.props.panel.tab !== 'metadata') {
      this.props.handleTabSelect('metadata')
    }
  }

  handleTagsTabSelect = () => {
    if (this.props.panel.tab !== 'tags') {
      this.props.handleTabSelect('tags')
    }
  }

  handlePhotoCreate = (event) => {
    event.stopPropagation()
    this.props.handlePhotoCreate({ item: this.props.item.id })
  }


  renderItemTabs() {
    const { panel, selection } = this.props

    return (
      <Tabs justified>
        <Tab
          active={panel.tab === 'metadata'}
          disabled={!selection.length}
          onActivate={this.handleMetadataTabSelect}>
          <IconMetadata/>
          <FormattedMessage id="panel.metadata"/>
        </Tab>
        <Tab
          active={panel.tab === 'tags'}
          disabled={!selection.length}
          onActivate={this.handleTagsTabSelect}>
          <IconTag/>
          <FormattedMessage id="panel.tags"/>
        </Tab>
      </Tabs>
    )
  }

  renderItemPanel() {
    const { selection, panel } = this.props

    switch (selection.length) {
      case 0:
        return <span>No items selected</span>

      case 1:
        switch (panel.tab) {
          case 'metadata':
            return this.renderMetadataPanel()
          case 'tags':
            return this.renderTagsPanel()
          default:
            return null
        }

      default:
        return <span>{selection.length} items selected</span>
    }
  }

  renderMetadataPanel() {
    const { photo, item } = this.props

    return (
      <div>
        {photo &&
          <Fields
            id={photo}
            disabled={this.disabled}
            template="photo"/>}
        {item &&
          <Fields
            id={item.id}
            disabled={this.disabled}
            template="core"/>}
      </div>
    )
  }

  renderTagsPanel() {
    const { item } = this.props

    return (
      <ul>
        {item && item.tags.map(tag => <li key={tag}>{tag}</li>)}
      </ul>
    )
  }

  renderPhotosToolbar() {
    return (
      <PhotoToolbar
        hasPhotoCreateButton={!this.disabled}
        onPhotoCreate={this.handlePhotoCreate}/>
    )
  }

  renderPhotoPanel() {
    const { item, photo } = this.props

    return item && (
      <PhotoList
        ids={item.photos}
        selected={photo}
        isDisabled={this.disabled}/>
    )
  }

  renderNotesToolbar() {
    return (
      <Toolbar>
        <div className="toolbar-left">
          <IconNote/>
          <h4><FormattedMessage id="panel.notes"/></h4>
        </div>
        <div className="toolbar-right">
          <button className="btn btn-icon"><IconPlus/></button>
        </div>
      </Toolbar>
    )
  }

  renderToolbar() {
    return (
      <Toolbar draggable={frameless}/>
    )
  }

  render() {
    return (
      <section id="item">
        <Resizable edge="left" value={320}>
          <PanelGroup header={this.renderToolbar()}>
            <Panel header={this.renderItemTabs()}>
              {this.renderItemPanel()}
            </Panel>

            <Panel header={this.renderPhotosToolbar()}>
              {this.renderPhotoPanel()}
            </Panel>

            <Panel header={this.renderNotesToolbar()}>
              <NoteList/>
            </Panel>
          </PanelGroup>
        </Resizable>

        <Viewer/>
      </section>
    )
  }

  static propTypes = {
    item: PropTypes.shape({
      id: PropTypes.number.isRequired,
      tags: PropTypes.arrayOf(PropTypes.number).isRequired,
      deleted: PropTypes.bool
    }),

    panel: PropTypes.shape({
      tab: PropTypes.oneOf(['metadata', 'tags']).isRequired
    }).isRequired,

    photo: PropTypes.number,
    selection: PropTypes.arrayOf(PropTypes.number),

    handleTabSelect: PropTypes.func,
    handlePhotoCreate: PropTypes.func
  }
}


module.exports = {
  Item: connect(
    (state) => ({
      item: getSelectedItem(state),
      photo: state.nav.photo,
      selection: state.nav.items,
      panel: state.nav.panel
    }),

    (dispatch) => ({
      handleTabSelect(tab) {
        dispatch(act.nav.panel.tab.select(tab))
      },

      handlePhotoCreate(...args) {
        dispatch(act.photo.create(...args))
      }
    })
  )(Item)
}
