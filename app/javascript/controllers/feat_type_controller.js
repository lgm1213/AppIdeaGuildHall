import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["originSection", "originLabel", "originInput", "originList"]
  static values  = { classNames: Array }

  connect() {
    this.#applyType(this.#selectedType())
  }

  typeChanged(event) {
    this.#applyType(event.target.value)
  }

  // private

  #applyType(type) {
    const config = {
      feat:               { show: false, label: "",             placeholder: "",                 options: [] },
      class_feature:      { show: true,  label: "Class",        placeholder: "e.g. Rogue",       options: this.classNamesValue },
      racial_feature:     { show: true,  label: "Race",         placeholder: "e.g. Half-Elf",    options: [] },
      background_feature: { show: true,  label: "Background",   placeholder: "e.g. Criminal",    options: [] },
    }[type] || { show: false, label: "", placeholder: "", options: [] }

    this.originSectionTarget.classList.toggle("hidden", !config.show)
    this.originLabelTarget.textContent  = config.label
    this.originInputTarget.placeholder  = config.placeholder

    this.#updateDatalist(config.options)
  }

  #updateDatalist(options) {
    this.originListTarget.innerHTML = options
      .map(name => `<option value="${name}">`)
      .join("")
  }

  #selectedType() {
    return this.element.querySelector("input[name='character_feat[feat_type]']:checked")?.value || "feat"
  }
}
