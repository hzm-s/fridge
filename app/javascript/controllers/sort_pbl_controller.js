import { Controller } from 'stimulus';
import Sortable, { AutoScroll } from 'sortablejs/modular/sortable.core.esm.js'

export default class extends Controller {
  initialize() {
    Sortable.mount(new AutoScroll())
  }

  connect() {
    const url = this.data.get('url')

    Sortable.create(this.element, {
      handle: this.data.get('handle'),
      scroll: true,
      animation: 150,
      easing: 'cubic-bezier(1, 0, 0, 1)',
      ghostClass: '.sortable-ghost',
      onEnd: function(e) {
        const payload = {
          pbi_id: e.item.dataset.sortableId,
          to: e.newIndex + 1
        }
        $.ajax({ type: 'PATCH', url: url, dataType: 'json', data: payload })
      }
    })
  }
}
