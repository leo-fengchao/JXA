delay(1);

var safari = Application('safari');
var chrome = Application('Google Chrome');
var systemEvents = Application('System Events');
systemEvents.includeStandardAdditions = true;

const frontmost_app_name = systemEvents.applicationProcesses.where({frontmost: true}).name()[0];

if (frontmost_app_name == 'Safari') {
  var safari_current_tab_url = safari.windows[0].currentTab.url();
  addToSafariReadingList(safari_current_tab_url);
} else if(frontmost_app_name == 'Google Chrome'){
  var chrome_current_tab_url = chrome.windows[0].activeTab.url();
  addToSafariReadingList(chrome_current_tab_url);
}else{
  //获取剪贴板
  var clipboardContent = systemEvents.theClipboard();
  var clipboardContentURL = checkURLOrNot(clipboardContent);
  //判断剪贴板内容是不是链接
  if (clipboardContentURL) {
    addToSafariReadingList(clipboardContentURL);
  } else {
    var app = Application.currentApplication();
    app.includeStandardAdditions = true;
    app.displayNotification('FAIL',{withTitle: '剪贴板内容不包含链接'});
  }
}

function addToSafariReadingList(url) {
  safari.addReadingListItem(url);
  var app = Application.currentApplication();
  app.includeStandardAdditions = true;
  app.displayNotification('SUCCES',
  { withTitle: '已添加到阅读列表'});
}

//判断是否是链接
function checkURLOrNot(url) {
  var expression = /[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi;
  var regex = new RegExp(expression);
  var t = url;

  if (t.match(regex)) {
    //返回数组中的第一个匹配
    return t.match(regex)[0];
  } else {
    //返回空值
    return null;
  }
}
