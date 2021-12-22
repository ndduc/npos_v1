// class test {
//    test() {
//     String t = "test";
//     switch(t) {
//     //region TAX HTTP EVENT
//       case MainEvent.Event_GetTaxPaginateCount:
//         yield GenericInitialState();
//         try {
//           yield TaxPaginateLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           String searchType = event.productParameter!["searchType"];
//           int count = await mainRepo.GetTaxPaginateCount(userId, locId!, searchType);
//           yield TaxPaginateCountLoadedState(count: count);
//         } catch (e) {
//           yield GenericErrorState(error: e);
//         }
//         break;
//       case MainEvent.Event_GetTaxPaginate:
//         yield GenericInitialState();
//         try {
//           yield TaxPaginateLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           String searchType = event.productParameter!["searchType"];
//           int startIdx = event.productParameter!["startIdx"];
//           int endIdx = event.productParameter!["endIdx"];
//           ConsolePrint("Map Param", event.productParameter);
//           List<TaxModel> listModel = await mainRepo.GetTaxPaginateByIndex(userId, locId!, searchType, startIdx, endIdx);
//           yield TaxPaginateLoadedState(listTaxModel: listModel);
//         } catch (e) {
//           yield GenericErrorState(error: e);
//         }
//         break;
//       case MainEvent.Event_GetTaxByDescription:
//         yield GenericInitialState();
//         try {
//           yield TaxPaginateLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           String description = event.taxParameter!["description"];
//           ConsolePrint("Map Param Event_GetTaxByDescription", event.taxParameter);
//           List<TaxModel> listModel = await mainRepo.GetTaxByDescription(userId, locId!, description);
//           yield TaxByDescriptionLoadedState(listTaxModel: listModel);
//         } catch (e) {
//           yield GenericErrorState(error: e);
//         }
//         break;
//       case MainEvent.Event_GetTaxById:
//         yield GenericInitialState();
//         try {
//           yield TaxLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           String taxId = event.taxParameter!["taxId"];
//           TaxModel res = await mainRepo.GetTaxById(userId, locId!, taxId);
//           yield TaxLoadedState(taxModel: res);
//         } catch (e) {
//           yield GenericErrorState(error: e);
//         }
//         break;
//       case MainEvent.Event_GetTaxs:
//       // This will be replaced with paginate endpoint - not valid at the moment
//         yield GenericInitialState();
//         try {
//           yield TaxPaginateLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           List<TaxModel> res = await mainRepo.GetTaxs(userId, locId!);
//           yield TaxPaginateLoadedState(listTaxModel: res);
//         } catch (e) {
//           yield GenericErrorState(error: e);
//         }
//         break;
//       case MainEvent.Event_AddTax:
//         yield Generic2ndInitialState();
//         try {
//           yield Generic2ndLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           Map<String, String> param = {
//             "desc": event.taxParameter!["desc"],
//             "note":event.taxParameter!["note"]
//           };
//           bool res = await mainRepo.AddTax(userId, locId!, param);
//           yield AddUpdateTaxLoaded(isSuccess: res);
//         } catch (e) {
//           yield Generic2ndErrorState(error: e);
//         }
//         break;
//       case MainEvent.Event_UpdateTax:
//         yield Generic2ndInitialState();
//         try {
//           yield Generic2ndLoadingState();
//           String userId = event.userData!.uid;
//           String? locId = event.userData!.defaultLocation!.uid;
//           Map<String, String> param = {
//             "desc": event.taxParameter!["desc"],
//             "note":event.taxParameter!["note"],
//             "id":event.taxParameter!["id"]
//           };
//           bool res = await mainRepo.UpdateTax(userId, locId!, param);
//           yield AddUpdateTaxLoaded(isSuccess: res);
//         } catch (e) {
//           yield Generic2ndErrorState(error: e);
//         }
//         break;
//     //endregion
//     }
//   }
// }