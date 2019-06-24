# PlaceholderView
Swift UIScrollView 无数据默认占位视图

### UIView+Placeholder 内部交换了 UITableView UICollectionView 的reloadData 方法 需要在AppDelegate中调用
```swift
 UITableView.exchangeMethod()
 UICollectionView.exchangeMethod()
```
并且保证第三方库中没有交换reloadData方法 比如旧版本的MJRefresh 中就交换了reloadData方法

### 通过下面方法调用
```swift
 self.tableView.showPlaceholderView = true; //无数据时显示占位视图
 self.tableView.placeholderView?.offset =  50; //占位视图与顶部距离
```
