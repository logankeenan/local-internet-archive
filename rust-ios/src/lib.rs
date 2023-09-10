use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use web_archive::{blocking};
use scraper::{Html, Selector};

#[no_mangle]
pub extern "C" fn archive_url(url: *const c_char, title: *mut *mut c_char, markup: *mut *mut c_char) {
    let input_str = unsafe {
        assert!(!url.is_null());
        CStr::from_ptr(url).to_string_lossy().into_owned()
    };


    let archive = blocking::archive(input_str.as_str(), Default::default()).unwrap();

    let page = archive.embed_resources();
    let document = Html::parse_document(page.as_str());
    let title_selector = Selector::parse("title").unwrap();
    let title_element = document.select(&title_selector).next().unwrap();
    let title_text = title_element.text().collect::<Vec<_>>().join("");


    let c_title = CString::new(title_text).unwrap();
    let c_markup = CString::new(page).unwrap();

    unsafe {
        *title = c_title.into_raw();
        *markup = c_markup.into_raw();
    }
}