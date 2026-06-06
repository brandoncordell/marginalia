import { Controller } from "@hotwired/stimulus"

// Progressively enhances a <form>: keeps its submit control disabled until every
// required field is filled in and the form is otherwise valid. Without JS the
// submit control stays enabled and the browser's native validation handles empty
// submissions.
//
// Connect it to the <form> element:
//   data-controller="form"
//   data-action="input->form#refresh change->form#refresh"
export default class extends Controller {
  connect() {
    this.refresh()
  }

  refresh() {
    const submit = this.submitButton
    if (submit) submit.disabled = !this.element.checkValidity()
  }

  // The submit control may live outside the <form> and be associated via the
  // `form` attribute, so resolve it through the form's controls collection
  // rather than a descendant query.
  get submitButton() {
    return Array.from(this.element.elements).find((element) => element.type === "submit")
  }
}
