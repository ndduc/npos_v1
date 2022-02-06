// ignore_for_file: file_names
// ignore_for_file: library_prefixes
// ignore_for_file: constant_identifier_names
// ignore_for_file: non_constant_identifier_names

const String HOST ="https://192.168.1.2:5001/";
const String MAIN_ENDPOINT = "api/pos/";
const String OK = "OK";
const String SLASH = "/";
const String BODY = "body";
const String UTF_8 = "utf-8";
const String GET = "get";
const String VERIFY = "verify";
const String AND = "&";
const String EQUAL = "=";
const String QUESTION = "?";

//region CATEGORY
const String CATEGORY = "/category/";
const String CATEGORY_GET = "/category/get";
const String CATEGORY_GET_COUNT = "/category/get-count";
const String CATEGORY_GET_PAGINATE = "/category/get-category-paginate";
const String CATEGORY_GET_BY_CATEGORY = "/category/get-by-category";
const String CATEGORY_ADD = "/category/add";
const String CATEGORY_UPDATE = "/category/update";
//endregion

//region DEPARTMENT
const String DEPARTMENT = "/department/";
const String DEPARTMENT_GET = "/department/get";
const String DEPARTMENT_GET_COUNT = "/department/get-count";
const String DEPARTMENT_GET_PAGINATE = "/department/get-department-paginate";
const String DEPARTMENT_GET_BY_DESCRIPTION = "/department/get-by-description";
const String DEPARTMENT_ADD = "/department/add";
const String DEPARTMENT_UPDATE = "/department/update";
//endregion

//region ITEM CODE
const String ITEMCODE = "/item-code/";
const String ITEMCODE_GET_PAGINATE = "/item-code/get-with-paginate";
const String ITEMCODE_ADD = "/item-code/add";
const String ITEMCODE_REMOVE = "/item-code/remove";
const String OFFSET = "offset";
const String LIMIT = "limit";
const String ORDER = "order";
//endregion

//region UPC
const String UPC = "/upc/";
const String UPC_GET_PAGINATE = "/upc/get-with-paginate";
const String UPC_ADD = "/upc/add";
const String UPC_REMOVE = "/upc/remove";
//endregion