import asyncio
from collections.abc import Awaitable
from typing import Callable, Generic, TypeVar

T = TypeVar("T")


class Debounced(Generic[T]):
    def __init__(self, func: Callable[[], Awaitable[T]], delay: float) -> None:
        self._func = func
        self._delay = delay
        self._task: asyncio.Task[T] | None = None

    def schedule(self) -> asyncio.Task[T]:
        self.cancel()

        async def _func_with_timer() -> T:
            await asyncio.sleep(self._delay)
            return await self._func()

        self._task = asyncio.create_task(_func_with_timer())
        return self._task

    def run(self) -> asyncio.Task[T]:
        self.cancel()

        self._task = asyncio.create_task(self._func())
        return self._task

    def cancel(self) -> None:
        if self._task is not None and not self._task.done():
            self._task.cancel()
            self._task = None

    def is_running(self) -> bool:
        return (
            self._task is not None
            and not self._task.done()
            and not self._task.cancelled()
            and not self._task.cancelling()
        )

    def __call__(self) -> asyncio.Task[T]:
        return self.run()


def debounced(delay: float) -> Callable[[Callable[[], Awaitable[T]]], Debounced[T]]:
    def decorator(func: Callable[[], Awaitable[T]]) -> Debounced[T]:
        return Debounced(func, delay)

    return decorator
