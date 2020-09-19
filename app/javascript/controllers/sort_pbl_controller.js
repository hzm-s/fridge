import { Controller } from 'stimulus';
import Sortable, { AutoScroll } from 'sortablejs/modular/sortable.core.esm.js'

const uiOptions = {
  handle: '.js-sortable-handle',
  scroll: true,
  animation: 150,
  easing: 'cubic-bezier(1, 0, 0, 1)',
  ghostClass: '.sortable-ghost'
}

export default class extends Controller {
  initialize() {
    Sortable.mount(new AutoScroll())
  }

  connect() {
    const url = this.data.get('url')
    const groupName = this.data.get('name')

    Sortable.create(this.element, {
      ...uiOptions,
      group: {
        name: groupName,
        pull: true,
        put: true
      },
      onEnd: function(e) {
        const payload = {
          item: e.item.dataset.id,
          from_release_id: e.from.dataset.releaseId,
          to_release_id: e.to.dataset.releaseId,
          newIndex: e.newIndex
        }
        if (payload.from_release_id != undefined || payload.to_release_id != undefined) {
          $.ajax({ type: 'PATCH', url: url, dataType: 'json', data: payload })
        }
      }
    })
  }
}
