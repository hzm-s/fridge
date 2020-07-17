import { Controller } from 'stimulus'
import Toastify from 'toastify-js'

export default class extends Controller {
  connect() {
    const message = this.data.get('message')
    Toastify({
      text: message,
      close: true,
      className: 'toast-success'
    }).showToast();
  }
}
