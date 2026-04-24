import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typeSelect", "weaponSection"]

  connect() {
    this.#toggle()
  }

  toggle() {
    this.#toggle()
  }

  #toggle() {
    const isWeapon = this.typeSelectTarget.value === "weapon"
    this.weaponSectionTarget.classList.toggle("hidden", !isWeapon)
  }
}
