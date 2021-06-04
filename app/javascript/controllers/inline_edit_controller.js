import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['showSection', 'editSection']

  connect() {
    this.showSectionOriginalStyle = this.showSectionTarget.style
    this.hideEditSection()
  }

  open(event) {
    event.preventDefault()
    event.stopPropagation()
    this.openEdit()
  }

  close(event) {
    event.preventDefault()
    this.closeEdit()
  }

  openEdit() {
    this.hideContentSection()
    this.exposeEditSection()
  }

  closeEdit() {
    this.hideEditSection()
    this.exposeShowSection()
  }

  exposeEditSection() {
    this.editSectionTarget.style.display = 'block'
  }

  exposeShowSection() {
    this.showSectionTarget.style = this.showSectionOriginalStyle
  }

  hideContentSection() {
    this.showSectionTarget.style.display = 'none'
  }

  hideEditSection() {
    this.editSectionTarget.style.display = 'none'
  }
}
