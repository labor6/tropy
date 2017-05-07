'use strict'

const React = require('react')
const { PureComponent } = React
const { PrefPane } = require('../prefs/pane')
const { Accordion, AccordionGroup } = require('../accordion')
const { FormField, FormText } = require('../form')
const { noop } = require('../../common/util')
const { array, bool, string } = require('prop-types')

const PropertyList = () => (
  <ul className="property-list">
    <li className="property">
      <fieldset>
        <FormField
          id="property.label"
          name="label"
          value="Title"
          isCompact
          size={8}
          onChange={function () {}}/>
        <FormText
          id="property.uri"
          isCompact
          value="http://..."/>
        <FormText
          id="property.description"
          isCompact
          value=""/>
        <FormText
          id="property.comment"
          isCompact
          value=""/>
      </fieldset>
    </li>
  </ul>
)

class VocabPane extends PureComponent {
  renderVocabulary(vocab, idx) {
    return (
      <Accordion id={idx} key={vocab.uri} onToggle={noop}>
        <h1 className="panel-heading">
          <input type="checkbox"/>
          {vocab.title}
        </h1>
        <FormText
          id="vocab.uri"
          isCompact
          value={vocab.uri}/>
        <FormField
          id="vocab.prefix"
          isCompact
          name="prefix"
          value=""
          size={8}
          onChange={noop}/>
        <FormText
          id="vocab.description"
          isCompact
          value={vocab.description}/>
        <PropertyList/>
      </Accordion>
    )
  }

  render() {
    return (
      <PrefPane
        name={this.props.name}
        isActive={this.props.isActive}>
        <AccordionGroup className="form-horizontal">
          {this.props.vocab.map(this.renderVocabulary)}
        </AccordionGroup>
      </PrefPane>
    )
  }

  static propTypes = {
    isActive: bool,
    name: string.isRequired,
    vocab: array.isRequired
  }

  static defaultProps = {
    name: 'vocab'
  }
}

module.exports = {
  VocabPane
}