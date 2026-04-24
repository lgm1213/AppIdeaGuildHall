import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static classes  = ["activeTab", "inactiveTab"]

  show(event) {
    const panelId = `panel-${event.params.panel}`

    this.panelTargets.forEach(panel => {
      panel.classList.toggle("hidden", panel.id !== panelId)
    })

    this.tabTargets.forEach(tab => {
      const isActive = tab === event.currentTarget
      this.activeTabClasses.forEach(c   => tab.classList.toggle(c, isActive))
      this.inactiveTabClasses.forEach(c => tab.classList.toggle(c, !isActive))
    })
  }
}
