import { Controller } from 'stimulus';

export default class extends Controller {
  scroll(e) {
    e.preventDefault()
    
    const anchor = this.data.get('to')
    const position = $(anchor).offset().top
    $('body,html').animate({ scrollTop: position }, 300, 'swing')
  }
}
