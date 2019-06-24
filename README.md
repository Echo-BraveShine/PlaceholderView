# PlaceholderView
Swift UIScrollView 无数据默认占位视图

### UIView+Placeholder 内部交换了 UITableView UICollectionView 的reloadData 方法 需要在AppDelegate中调用
```swift
UITableView.exchangeMethod()
UICollectionView.exchangeMethod()
```
并且保证第三方库中没有交换reloadData方法 比如旧版本的MJRefresh 中就交换了reloadData方法

