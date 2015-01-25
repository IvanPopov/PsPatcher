React = require "react-atom-fork"

STATES = [
  'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI',
  'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS',
  'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR',
  'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
]

module.exports = React.createClass
  getInitialState: ->
    email: true
    question: true
    submitted: null

  render: ->
    submitted = undefined
    if @state.submitted isnt null
      submitted =
      <div className="alert alert-success">
        <p>ContactForm data:</p>
        <pre><code>{JSON.stringify @state.submitted, null, '  '}</code></pre>
      </div>

    <div>
      <div className="panel panel-default">
        <div className="panel-heading clearfix">
          <h3 className="panel-title pull-left">Contact Form</h3>
          <div className="pull-right">
            <label className="checkbox-inline">
              <input type="checkbox"
                checked={@state.email}
                onChange={@handleChange.bind(this, 'email')}
              /> Email
            </label>
            <label className="checkbox-inline">
              <input type="checkbox"
                checked={@state.question}
                onChange={@handleChange.bind(this, 'question')}
              /> Question
            </label>
          </div>
        </div>
        <div className="panel-body">
          <ContactForm ref="contactForm"
            email={@state.email}
            question={@state.question}
            company={@props.company}
          />
        </div>
        <div className="panel-footer">
          <button type="button" className="btn btn-primary btn-block" onClick={@handleSubmit}>Submit</button>
        </div>
      </div>
      {submitted}
    </div>

  handleChange: (field, e) ->
    nextState = {}
    nextState[field] = e.target.checked
    @setState nextState


  handleSubmit: () ->
    if @refs.contactForm.isValid()
      @setState {submitted: @refs.contactForm.getFormData()}


# A contact form with certain optional fields.
ContactForm = React.createClass
  getDefaultProps: ->
    email: true
    question: false

  getInitialState: ->
    errors: {}

  isValid: ->
    fields = ['firstName', 'lastName', 'phoneNumber', 'address', 'city', 'state', 'zipCode']
    if @props.email then fields.push 'email'
    if @props.question then fields.push 'question'

    errors = {}
    fields.forEach ((field) ->
        value = trim @refs[field].getDOMNode().value
        if !value then errors[field] = 'This field is required'
      ).bind(this)
    @setState {errors: errors}

    isValid = true
    for error of errors
      isValid = false
      break

    isValid

  getFormData: ->
    data =
      firstName: @refs.firstName.getDOMNode().value
      lastName: @refs.lastName.getDOMNode().value
      phoneNumber: @refs.phoneNumber.getDOMNode().value
      address: @refs.address.getDOMNode().value
      city: @refs.city.getDOMNode().value
      state: @refs.state.getDOMNode().value
      zipCode: @refs.zipCode.getDOMNode().value
      currentCustomer: @refs.currentCustomerYes.getDOMNode().checked

    if @props.email then data.email = @refs.email.getDOMNode().value
    if @props.question then data.question = @refs.question.getDOMNode().value
    data

  render: ->
    <div className="form-horizontal">
      {@renderTextInput 'firstName', 'First Name'}
      {@renderTextInput 'lastName', 'Last Name'}
      {@renderTextInput 'phoneNumber', 'Phone number'}
      {@props.email && @renderTextInput 'email', 'Email'}
      {@props.question && @renderTextarea 'question', 'Question'}
      {@renderTextInput 'address', 'Address'}
      {@renderTextInput 'city', 'City'}
      {@renderSelect 'state', 'State', STATES}
      {@renderTextInput 'zipCode', 'Zip Code'}
      {@renderRadioInlines 'currentCustomer', "Are you currently a #{@props.company} Customer?", {
        values: ['Yes', 'No']
        defaultCheckedValue: 'No'
      }}
    </div>


  renderTextInput: (id, label) ->
    @renderField id, label,
      <input type="text" className="form-control" id={id} ref={id}/>



  renderTextarea: (id, label) ->
    @renderField id, label,
      <textarea className="form-control" id={id} ref={id}/>


  renderSelect: (id, label, values) ->
    options = values.map (value) ->
      <option value={value}>{value}</option>

    @renderField id, label,
      <select className="form-control" id={id} ref={id}>{options}</select>

  renderRadioInlines: (id, label, kwargs) ->
    radios = kwargs.values.map (value) ->
      defaultChecked = value is kwargs.defaultCheckedValue
      <label className="radio-inline">
        <input type="radio" ref={id + value} name={id} value={value} defaultChecked={defaultChecked}/>
        {value}
      </label>

    @renderField(id, label, radios)


  renderField: (id, label, field) ->
    <div className={$c('form-group', {'has-error': id of @state.errors})}>
      <label htmlFor={id} className="col-sm-4 control-label">{label}</label>
      <div className="col-sm-6">
        {field}
      </div>
    </div>


#React.renderComponent <Example company="FakeCo"/>, document.getElementById 'contactform'

# Utils

trim = (() ->
  TRIM_RE = /^\s+|\s+$/g
  (string) ->
    string.replace(TRIM_RE, '')
)()

$c = (staticClassName, conditionalClassNames) ->
  classNames = []
  if !conditionalClassNames?
    conditionalClassNames = staticClassName
  else
    classNames.push staticClassName

  for className of conditionalClassNames
    if !!conditionalClassNames[className]
      classNames.push(className)

  classNames.join ' '
