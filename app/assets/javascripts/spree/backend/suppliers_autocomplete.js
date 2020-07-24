$.fn.supplierAutocomplete = function () {
  'use strict';

  this.select2({
    placeholder: Spree.translations.supplier_placeholder,
    multiple: true,
    initSelection: function (element, callback) {
      var ids = element.val(),
          count = ids.split(",").length;

      Spree.ajax({
        type: "GET",
        url: suppliers_search,
        data: {
          ids: ids,
          per_page: count
        },
        success: function (data) {
          callback(data['suppliers']);
        }
      });
    },
    ajax: {
      url: suppliers_search,
      datatype: 'json',
      data: function (term, page) {
        return {
          per_page: 50,
          page: page,
          q: {
            name_cont: term
          },
          token: Spree.api_key
        };
      },
      results: function (data, page) {
        var more = page < data.pages;
        return {
          results: data['suppliers'],
          more: more
        };
      }
    },
    formatResult: function (supplier, container, query, escapeMarkup) {
      return escapeMarkup(supplier.name);
    },
    formatSelection: function (supplier, container, escapeMarkup) {
      return escapeMarkup(supplier.name);
    }
  });
};

$(document).ready(function () {
  $('#product_supplier_ids').supplierAutocomplete();
});
